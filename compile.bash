#!/bin/bash

if [ -n "$ROS_DISTRO" ]; then
    echo "Terminal has already been sourced for ROS2! Please open a fresh terminal and try again."
    exit 1
fi

cd $HOME/unitree_ros2_default/unitree_ws/

echo "Removing old compilation"
rm -rf build install log

echo "Compiling cyclonedds dependancy"
colcon build --packages-select cyclonedds
source $HOME/unitree_ros2_default/setup.sh

echo "Compiling all packages"
colcon build
source $HOME/unitree_ros2_default/setup.sh

echo "Compilation Complete"


