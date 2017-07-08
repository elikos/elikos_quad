#!/bin/bash

# Valeurs par défauts
SUBMODULES=false
DEPENDENCIES=false
BUILD=false

# Extraction des paramètres
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    build)
    BUILD=true
    shift
    ;;
    init)
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
    echo 'Installation des dépendances (indigo)!'
    sudo apt-get install -y ros-$ROS_DISTRO-mavros ros-$ROS_DISTRO-mavros-extras ros-$ROS_DISTRO-pointgrey-camera-driver ros-$ROS_DISTRO-moveit
    sudo apt install -y python-pip
    sudo pip install --upgrade pip
    sudo pip install numba scipy numpy numpy-quaternion
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

echo 'All done!'
