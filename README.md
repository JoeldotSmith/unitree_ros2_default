# Introduction
This is a base repository for the G1 robot which contains all the base data to get started working on it.

This was nessacessy are the base repository (https://github.com/unitreerobotics/unitree_ros2?tab=readme-ov-file) is built for other robots such as the Go1 and H1 which has different hardware than the G1 such as Lidar

This was made and has only been tested on

|systems|ROS2 distro|
|--|--|
|Ubuntu 20.04|foxy|

## Prerequisites

The installation of ROS2 foxy can refer to: https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html


The installation of Livox-SDK2 can refer to: https://github.com/Livox-SDK/Livox-SDK2


## Installation

Please clone this repo in your base directory
```bash
cd
git clone https://github.com/JoeldotSmith/unitree_ros2_default
```

### Editing before compiling

Please connect to the robot via ethernet.

Next, open the network settings, find the network interface that the robot connected.In IPv4 setting, change the IPv4 mode to manual, set the address to 192.168.123.103, and set the mask to 255.255.255.0. After completion, click apply and wait for the network to reconnect.

More detailed instructions can be found in the unitree_ros2 repo

run 
```bash
ifconfig
```
to find the name of the connection mine is 'enx00e04c680157' *a wired connection to the robot will always start with en*

the inside the unitree_ros2_default/setup.sh file, replace the name in the NetworkInterface in the with the name of your wired connection, like below and save the file.
``` bash
echo "Setup unitree ros2 environment"
source /opt/ros/foxy/setup.bash
echo "Setup unitree cyclonedds_ws"
source $HOME/unitree_ros2_default/cyclonedds_ws/install/setup.bash
echo "Setup unitree go/api/hg"
source $HOME/unitree_ros2_default/install/setup.bash
echo "Setup unitree ws_livox"
source $HOME/unitree_ros2_default/ws_livox/install/setup.sh
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI='<CycloneDDS><Domain><General><Interfaces>
                            <NetworkInterface name="enx00e04c680157" priority="default" multicast="default" />
                        </Interfaces></General></Domain></CycloneDDS>'
```


### Compilation

Then a create script has been created to make first compiling easier

**PLEASE DO NOT RUN THIS SCRIPT WITHOUT THROUGHLY READING AND UNDERSTANDING WHAT IT DOES**

```bash
cd ~/unitree_ros2_default
./create.bash
```

*This script has not been finalised there may be come errors*

Next source the enviroment with

```bash
cd ~/unitree_ros2_default
source setup.sh
```

Testing, ros should now be active and if you run 
```bash
ros2 pkg list
```
you should see both 
```bash
/livox_ros_driver2
/unitree_go
/unitree_api
/unitree_hg
```
in the list.








