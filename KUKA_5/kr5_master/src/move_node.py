#!/usr/bin/env python

import cv2
from cv_bridge import CvBridge, CvBridgeError
import rospy
import numpy as np

import rospy
import moveit_commander
import moveit_msgs.msg
import geometry_msgs.msg
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import time

class BottleColorDetector(object):
    def __init__(self):
        self.image_sub = rospy.Subscriber("/camera1/color/image_raw", Image, self.camera_callback)
        self.bridge_object = CvBridge()
        moveit_commander.roscpp_initialize([])
        self.robot = moveit_commander.RobotCommander()
        self.arm_group = moveit_commander.MoveGroupCommander("kuka_arm")
        self.gripper_group = moveit_commander.MoveGroupCommander("gripper")

        self.pick_pose = self.arm_group.get_named_target_values("pick_pose")
        self.lift_pose = self.arm_group.get_named_target_values("lift_pose")
        self.blue_pose = self.arm_group.get_named_target_values("blue_pose")
        self.red_pose = self.arm_group.get_named_target_values("red_pose")
        self.open_gripper = self.gripper_group.get_named_target_values("open_gripper")
        self.closed_gripper = self.gripper_group.get_named_target_values("closed_gripper")

        self.detected_color = None

    def camera_callback(self, data):
        if self.detected_color is None:
            try:
                cv_image = self.bridge_object.imgmsg_to_cv2(data, desired_encoding="bgr8")
                image = cv2.resize(cv_image, (100, 100))
                hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

                # Ranges for red and blue colors in HSV
                min_red = np.array([0, 100, 100])
                max_red = np.array([10, 255, 255])
                min_blue = np.array([100, 100, 100])
                max_blue = np.array([130, 255, 255])

                mask_red = cv2.inRange(hsv, min_red, max_red)
                mask_blue = cv2.inRange(hsv, min_blue, max_blue)

                num_red_pixels = np.count_nonzero(mask_red)
                num_blue_pixels = np.count_nonzero(mask_blue)

                if num_red_pixels > num_blue_pixels:
                    self.detected_color = "red"
                elif num_blue_pixels > num_red_pixels:
                    self.detected_color = "blue"
                else:
                    self.detected_color = None

            except CvBridgeError as e:
                print(e)

    def run(self):
        while not rospy.is_shutdown():
            self.move_to_pose("pick_pose")
            self.gripper_group.set_joint_value_target(self.open_gripper)
            self.gripper_group.go(wait=True)

            while self.detected_color is None:
                pass  # Esperar a que se detecte un color
            
            time.sleep(0.60)
            self.gripper_group.set_joint_value_target(self.closed_gripper)
            self.gripper_group.go(wait=True)
            time.sleep(0.5)  # Esperar medio segundo

            self.move_to_pose("lift_pose")  # Nueva pose antes de moverse a los colores

            if self.detected_color == "blue":
                self.move_to_pose("blue_pose")
            elif self.detected_color == "red":
                self.move_to_pose("red_pose")

            self.gripper_group.set_joint_value_target(self.open_gripper)
            self.gripper_group.go(wait=True)

            time.sleep(1)

            self.move_to_pose("pick_pose")
            self.detected_color = None

    def move_to_pose(self, pose_name):
        self.arm_group.set_named_target(pose_name)
        self.arm_group.go(wait=True)

def main():
    bottle_color_detector = BottleColorDetector()
    rospy.init_node('bottle_color_detector', anonymous=True)
    bottle_color_detector.run()
    try:
        rospy.spin()
    except KeyboardInterrupt:
        print("Goodbye")

if __name__ == '__main__':
    main()
