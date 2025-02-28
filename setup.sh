#!/bin/bash
echo "Setup unitree ros2 environment"
source /opt/ros/foxy/setup.bash
echo "Setup unitree cyclonedds_ws"
source $HOME/unitree_ros2/cyclonedds_ws/install/setup.bash
echo "Setup unitree ws_livox"
source $HOME/unitree_ros2/ws_livox/install/setup.bash
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI='<CycloneDDS><Domain><General><Interfaces>
                            <NetworkInterface name="enx00e04c680157" priority="default" multicast="default" />
                        </Interfaces></General></Domain></CycloneDDS>'
