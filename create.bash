#!/bin/bash

# sudo permissions
if [ "$EUID" -ne 0]; then
    echo "This script requires sudo permissions. Please enter your password"
    exec sudo "$0" "$@"
    exit
fi

echo "Running with sudo privileges..."

# dependencies
sudo apt install python3-colcon-common-extensions
sudo apt install ros-foxy-rmw-cyclonedds-cpp
sudo apt install ros-foxy-rosidl-generator-dds-idl


cd ~/unitree_ros2_default/cyclonedds_ws
colcon build --packages-select cyclonedds #Compile cyclone-dds package


cd ..
./ws_livox/src/livox_ros_driver2/build.sh ROS2


source setup.sh
cd ~/unitree_ros2_default
colcon build # Compile all packages in the workspace