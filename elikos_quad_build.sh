#!/bin/bash

echo 'driver-ws'
catkin build --workspace driver-ws/
echo 'Sourcing driver-ws'
source driver-ws/devel/setup.bash

echo 'util-ws'
catkin build --workspace util-ws/
echo 'Sourcing util-ws'
source util-ws/devel/setup.bash

echo 'elikos-ws'
catkin build --workspace elikos-ws/
echo 'Sourcing elikos-ws'
source elikos-ws/devel/setup.bash

echo 'All done!'