# Final Project MSR G6
# Kuka KR 5 - Pick and Place Automation

## One-time Gazebo Setup:
Check your Gazebo version using a terminal:
```
$ gazebo --version
```
Ensure version 11.11.0+ is installed. To update if needed:
```
$ sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
$ wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install gazebo11
```
Verify the correct version:
```
$ gazebo --version
```
## Workspace Setup:
Assuming your ROS workspace is named 'catkin_ws':
If no workspace, create one:
```
$ mkdir -p ~/catkin_ws/src
$ cd ~/catkin_ws/
$ catkin_make
```
Clone this repository into the 'src' directory:
```
$ cd ~/catkin_ws/src
$ git clone https://github.com/djavorti/Final_Project_MSR_G6.git
```
Install dependencies from terminal:
```
$ cd ~/catkin_ws
$ sudo apt-get update
$ rosdep install --from-paths src --ignore-src -r -y
$ sudo apt install ros-noeitc-industrial-core
$ sudo apt install python3-catkin-pkg-modules python3-rospkg-modules python3-empy
$ pip3 install pyyaml
$ pip3 install rospkg
$ cd ~/catkin_ws/src/KUKA_5/kr5_master/src
$ sudo chmod +x color_sensor.py
$ sudo chmod +x move_node.py
$ cd ~/catkin_ws/src/conveyor_demo/src/demo_world/src
$ sudo chmod +x spawn_medicines.py
```
You can launch the project by
```
roslaunch kr5_gazebo kr5_gazebo.launch gripper_2f:=true camera:=true
```
Then, in another terminal window, run the gazebo:
```
roslaunch kuka5_move move_group.launch
```
In another one, start the node for the movement of the robot:
```
rosrun kr5_master move_node.py
```
Once again, in another one, start the node to spawn medicines:
```
rosrun demo_world spawn_medicines.py
```
Finally, start the movement of the conveyor belt in a new terminal window:
```
rosservice call /conveyor/control "power: 30.0"
```
Optional: If you ever want to check the color sensor camera, you can run this in another terminal window:
```
rosrun kr5_master color_sensor.py
```

