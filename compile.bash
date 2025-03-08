#!/bin/bash

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


# Get all packages
# Clone repositories if they don't exist
# cyclonedds and rmw_cyclonedds are required to run ros on the g1
if [[ ! -d "$SRC_DIR/rmw_cyclonedds/.git" ]]; then
    echo "Cloning rmw_cyclonedds..."
    rm -rf "$SRC_DIR/rmw_cyclonedds"  # Ensure no remnants
    git clone --depth=1 --branch foxy https://github.com/ros2/rmw_cyclonedds.git "$SRC_DIR/rmw_cyclonedds"
else
    echo "rmw_cyclonedds already exists, skipping clone"
fi

if [[ ! -d "$SRC_DIR/cyclonedds/.git" ]]; then
    echo "Cloning cyclonedds..."
    rm -rf "$SRC_DIR/cyclonedds"  # Ensure no remnants
    git clone --depth=1 --branch releases/0.10.x https://github.com/eclipse-cyclonedds/cyclonedds.git "$SRC_DIR/cyclonedds"
else
    echo "cyclonedds already exists, skipping clone"
fi



# Optional package
# comment out if you don't want/need mocopi intergration
if [[ ! -d "$SRC_DIR/mocopi_ros2/.git" ]]; then
    echo "Cloning mocopi_ros2..."
    rm -rf "$SRC_DIR/mocopi_ros2"  # Ensure no remnants
    git clone --depth=1 https://github.com/JoeldotSmith/mocopi_ros2.git "$SRC_DIR/mocopi_ros2"
else
    echo "mocopi_ros2 already exists, skipping clone"
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
