#!/bin/bash

if [ -n "$ROS_DISTRO" ]; then
    echo "Terminal has already been sourced for ROS2! Please open a fresh terminal and try again."
    exit 1
fi

cd $HOME/unitree_ros2_default/unitree_ws/src/
git clone https://github.com/ros2/rmw_cyclonedds -b foxy
git clone https://github.com/eclipse-cyclonedds/cyclonedds -b releases/0.10.x
cd ..

echo "Removing old compilation"
rm -rf build install log

echo "Building Livox Drivers"
./src/livox_ros_driver2/build.sh ROS2

echo "Compiling cyclonedds dependancy"
colcon build --packages-select cyclonedds

source $HOME/unitree_ros2_default/setup.sh

echo "Compiling all packages"
cd $HOME/unitree_ros2_default/unitree_ws
colcon build
source $HOME/unitree_ros2_default/setup.sh

echo "Compilation Complete"


