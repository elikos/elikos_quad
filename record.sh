#!/bin/bash
rosbag record /tf /camera_bottom/image_rect_color/compressed /camera_bottom/camera_info /r200_front/color/image_raw/compressed /r200_front/color/camera_info -e "/mavros/(.*)" /r200_front/depth/image_raw/compressed
