#!/bin/bash

NO_MOCOPI=0
for arg in "$@"; do
  if [[ "$arg" == "-no-mocopi" ]]; then
    NO_MOCOPI=1
  fi
done

# Check if terminal has been sourced
# this matters for the cyclonedds compilation as the docs
# state that the terminal cannot be sourced before compilation
if [[ -n "${ROS_DISTRO:-}" ]]; then
  echo "Terminal has already been sourced for ROS2! Please open a fresh terminal and try again."
  exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPO_DIR="$SCRIPT_DIR/unitree_ws"
SRC_DIR="$REPO_DIR/src"

# make sure /src exists
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

clone_repo() {
  local name="$1"
  local url="$2"
  local branch="$3"
  local target="$SRC_DIR/$name"

  if [[ ! -d "$target/.git" ]]; then
    echo "Cloning $name..."
    rm -rf "$target"
    if [[ -n "$branch" ]]; then
      git clone --depth=1 --branch "$branch" "$url" "$target"
    else
      git clone --depth=1 "$url" "$target"
    fi
  else
    echo "$name already exists, skipping clone"
  fi
}

# Get all packages

# Required Packages
# cyclonedds and rmw_cyclonedds are required to run ros on the g1
clone_repo rmw_cyclonedds https://github.com/ros2/rmw_cyclonedds.git foxy
clone_repo cyclonedds https://github.com/eclipse-cyclonedds/cyclonedds.git releases/0.10.x

# Optional packages
if [[ "$NO_MOCOPI" -eq 0 ]]; then
  clone_repo mocopi_ros2 https://github.com/JoeldotSmith/mocopi_ros2.git g1
  clone_repo mocopi_2_unitree https://github.com/JoeldotSmith/mocopi_2_unitree.git
  clone_repo fcl_self_collision_checker https://github.com/JoeldotSmith/fcl_self_collision_checker.git SafetyMargin
  clone_repo g1_pose_follower https://github.com/JoeldotSmith/g1_pose_follower.git
else
  echo "Skipping mocopi-related packages"
fi

# Clean old compile
cd "$REPO_DIR"
echo "Removing old compilation"
rm -rf build install log

# building the lidar drivers seperately
# as the docs state it should be built using the build.sh file
# rather than colcon build
echo "Building Livox Drivers"
if [[ -x "$SRC_DIR/livox_ros_driver2/build.sh" ]]; then
  ./src/livox_ros_driver2/build.sh ROS2
else
  echo "Error: livox_ros_driver2 build script not found or not executable"
  exit 1
fi

# building the cyclonedds dependency first
# as other packages rely on it for building
echo "Compiling Cyclone DDS dependency"
colcon build --packages-select cyclonedds

if [[ -f "$HOME/unitree_ros2_default/setup.sh" ]]; then
  source "$HOME/unitree_ros2_default/setup.sh"
else
  echo "Error: setup.sh not found"
  exit 1
fi

# compiling the rest of the packages
echo "Compiling all packages"
cd "$REPO_DIR"
colcon build

echo "Compilation Complete"
