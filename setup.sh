#!/bin/bash
echo "Setup unitree ros2 environment"
source /opt/ros/foxy/setup.bash
source ~/.bashrc
echo "Setup unitree unitree workspace"
source $HOME/unitree_ros2_default/unitree_ws/install/setup.bash
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI='<CycloneDDS><Domain><General><Interfaces>
                            <NetworkInterface name="enx3ce1a1426e26" priority="default" multicast="default" />
                        </Interfaces></General></Domain></CycloneDDS>'
