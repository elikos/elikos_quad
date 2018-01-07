#!/bin/bash

# Valeurs par défauts
SUBMODULES=false
DEPENDENCIES=false
BUILD=true
CLEAN=false

# Extraction des paramètres
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    build)
    BUILD=true
    shift
    ;;
    clean)
	BUILD=false
    CLEAN=true
    shift
    ;;
    init)
	BUILD=false
    if [ "$2" = --dep ] ; then
        DEPENDENCIES=true
    elif [ "$2" = --submod ] ; then
        SUBMODULES=true
    fi
    if [ "$3" = --dep ] ; then
        DEPENDENCIES=true
    elif [ "$3" = --submod ] ; then
        SUBMODULES=true
    fi
    shift
    ;;
    *)
    ;;
esac
shift
done

# Dependencies
if [ "$DEPENDENCIES" = true ] ; then
    echo 'Installation des dépendances (kinetic)!'
    sudo apt-get install -y ros-$ROS_DISTRO-mavros ros-$ROS_DISTRO-mavros-extras ros-$ROS_DISTRO-pointgrey-camera-driver ros-$ROS_DISTRO-moveit ros-$ROS_DISTRO-mavros-msgs 
    sudo apt install -y python-pip
    sudo pip install --upgrade pip
    sudo pip install numba scipy numpy numpy-quaternion catkin_tools
    # Install Intel RealSense SDK for Linux
    sudo apt-key adv --keyserver keys.gnupg.net --recv-key D6FB2970 
    sudo sh -c 'echo "deb http://realsense-alm-public.s3.amazonaws.com/apt-repo xenial main" > /etc/apt/sources.list.d/realsense-latest.list'
    sudo apt update 
    sudo apt install -y librealsense-object-recognition-dev librealsense-persontracking-dev librealsense-slam-dev libopencv-dev
    sudo apt-get install ros-$ROS_DISTRO-realsense-camera
    sudo apt install screen
fi

# Submodules init
if [ "$SUBMODULES" = true ] ; then
    echo 'Initialisation des submodules!'
    git submodule init
	git submodule update --recursive --remote
fi

# Build
if [ "$BUILD" = true ] ; then
    echo 'Building!'

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
fi

# Clean
if [ "$CLEAN" = true ] ; then
    echo 'Cleaning!'

    echo 'driver-ws'
    catkin clean --workspace driver-ws/ --y

    echo 'util-ws'
    catkin clean --workspace util-ws/ --y

    echo 'elikos-ws'
    catkin clean --workspace elikos-ws/ --y
fi

echo 'All done!'
