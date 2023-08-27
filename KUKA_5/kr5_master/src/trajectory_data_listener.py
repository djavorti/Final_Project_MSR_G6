#!/usr/bin/env python

import rospy
from control_msgs.msg import JointTrajectoryControllerState

# Lists to store velocity and acceleration data
velocity_data = []
acceleration_data = []

def arm_controller_state_callback(data):
    global velocity_data, acceleration_data
    # Access velocity and acceleration data from data.actual
    velocity = data.actual.velocities
    acceleration = data.actual.accelerations
    
    # Store the data in the lists
    velocity_data.append(velocity)
    acceleration_data.append(acceleration)
    
    # You can also process the data or perform any other operations here

if __name__ == "__main__":
    rospy.init_node("velocity_acceleration_subscriber")
    
    rospy.Subscriber("/arm_controller/state", JointTrajectoryControllerState, arm_controller_state_callback)
    
    rospy.spin()

