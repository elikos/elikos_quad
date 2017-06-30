#!/bin/bash

catkin build --workspace driver-ws/
source driver-ws/devel/setup.sh

catkin build --workspace util-ws/
source util-ws/devel/setup.sh

catkin build --workspace elikos-ws/
source elikos-ws/devel/setup.sh