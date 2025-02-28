# Introduction
This is a base repository for the G1 robot which contains all the base data to get started working on it.

This was nessacessy are the base repository (https://github.com/unitreerobotics/unitree_ros2?tab=readme-ov-file) is built for other robots such as the Go1 and H1 which has different hardware than the G1 such as Lidar

This was made and has only been tested on

|systems|ROS2 distro|
|--|--|
|Ubuntu 20.04|foxy|

The installation of ROS2 foxy can refer to: https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html


Please clone this repo in your base directory
```bash
cd
git clone https://github.com/JoeldotSmith/unitree_ros2_default
```

## Installation guide for the ROS2 package from the unitree_ros2 github page
## Install Unitree ROS2 package

### 1. Dependencies
```bash
sudo apt install python3-colcon-common-extensions
sudo apt install ros-foxy-rmw-cyclonedds-cpp
sudo apt install ros-foxy-rosidl-generator-dds-idl
```

### 2. Compile cyclone dds
The cyclonedds version of Unitree robot is 0.10.2. To communicate with Unitree robots using ROS2, it is necessary to change the dds implementation. See：https://docs.ros.org/en/foxy/Concepts/About-Different-Middleware-Vendors.html

Before compiling cyclonedds, please ensure that ros2 environment has **NOT** been sourced when starting the terminal. Otherwise, it may cause errors in compilation.

If "source/opt/ros/foxy/setup. bash" has been added to the ~/.bashrc file when installing ROS2, it needs to be commented out:

```bash
sudo apt install vim
sudo vim ~/.bashrc
``` 
```bash
# source /opt/ros/foxy/setup.bash 
```


Compile cyclone-dds
```bash
cd ~/unitree_ros2_default/cyclonedds_ws
colcon build --packages-select cyclonedds #Compile cyclone-dds package
```

### 3. Compile unitree_go and unitree_api packages
After compiling cyclone-dds, ROS2 dependencies is required for compilation of the unitree_go and unitree_api packages. Therefore, before compiling, it is necessary to source the environment of ROS2.
```bash
source /opt/ros/foxy/setup.bash # source ROS2 environment
cd ~/unitree_ros2_default
colcon build # Compile all packages in the workspace
```

## Connect to Unitree robot

### 1. Network configuration
Connect Unitree robot and the computer using Ethernet cable. Then, use ifconfig to view the network interface that the robot connected. For example, "enp3s0" in the following figure.
![image](https://alidocs.oss-cn-zhangjiakou.aliyuncs.com/res/W4j6OJ2awDgbO3p8/img/5d22c143-5dad-4964-81f3-55864906a9f0.png)

Next, open the network settings, find the network interface that the robot connected.In IPv4 setting, change the IPv4 mode to manual, set the address to 192.168.123.99, and set the mask to 255.255.255.0. After completion, click apply and wait for the network to reconnect.
![image](https://alidocs.oss-cn-zhangjiakou.aliyuncs.com/res/W4j6OJ2awDgbO3p8/img/721e1660-04dc-42b7-8d6e-14799afe2165.png)

Open setup.sh file.
```bash
sudo gedit ~/unitree_ros2/setup.sh
```
```bash
#!/bin/bash
echo "Setup unitree ros2 environment"
source /opt/ros/foxy/setup.bash
source $HOME/unitree_ros2/cyclonedds_ws/install/setup.bash
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI='<CycloneDDS><Domain><General><Interfaces>
                            <NetworkInterface name="enp3s0" priority="default" multicast="default" />
                        </Interfaces></General></Domain></CycloneDDS>'
```
where "enp3s0" is the network interface name of unitree robot connected.
Modify it to the corresponding network interface according to the actual situation. 

Source the environment to setup the ROS2 support of Unitree robot: 
```bash
source ~/unitree_ros2/setup.sh
```
If you don't want to source the bash script every time when a new terminal opens, you can write the content of bash script into ~/.bashrc, but attention should be paid when there are multiple ROS environments coexisting in the system.

If your computer is not connected to the robot but you still want to use Unitree ROS2 for simulation and other functions, you can use the local loopback "lo" as the network interface.
```bash
source ~/unitree_ros2/setup_local.sh # use "lo" as the network interface
```
or
```bash
source ~/unitree_ros2/setup_default.sh # No network network interface specified 
```


### 2. Connect and test
After completing the above configuration, it is recommended to restart the computer before conducting the test.

Ensure that the network of robot is connected correctly, open a terminal and input:  
```bash
source ~/unitree_ros2/setup.sh
ros2 topic list
```
You can see the following topics:
![image](https://alidocs.oss-cn-zhangjiakou.aliyuncs.com/res/W4j6OJ2awDgbO3p8/img/5e45e8ec-9248-47eb-8380-798ed0ef468b.png)

Input ros2 topic echo /sportmodestate，you can see the data of the topic as shown in the following figure：
![image](https://alidocs.oss-cn-zhangjiakou.aliyuncs.com/res/W4j6OJ2awDgbO3p8/img/89214761-6cfb-4b52-bf24-7a5bd9a9806c.png)

## End of Installation guide from unitree_ros2 repo

## Lidar 


From the unitree_ros2_defualt directory run


```bash
./ws_livox/src/livox_ros_driver2/build.sh ROS2
```

This builds the livox lidar drivers and files

