#!/bin/bash

# Valeurs par défauts
START=true
STOP=false
VICON=false
STATIC_TRANSFORM=false
ORIGIN_INIT=false
X=0
Y=0
Z=2

# Extraction des paramètres
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    start)
    START=true
    STOP=false
    if [ "$2" = --vicon ] ; then
        VICON=true
    elif [ "$2" = --static ] ; then
        STATIC_TRANSFORM=true
        X="$3"
        Y="$4"
        Z="$5"
    fi
    shift
    ;;
    stop)
    START=false
    STOP=true
    shift
    ;;
    -i|--init)
    ORIGIN_INIT=true
    START=false
    STOP=false
    VICON=false
    shift
    ;;
    *)
    ;;
esac
shift
done

# Démarrage de vicon_bridge.
if [ "$VICON" = true ] ; then
    echo 'Démarrage de vicon_bridge!'
    source ~/ros-workspaces/util-ws/devel/setup.bash
    roslaunch elikos_vicon_remapping elikos_vicon_remapping.launch &
fi
# Démarrage des processus.
if [ "$START" = true ] ; then
    echo 'Démarrage des processus!'
    ~/ros-workspaces/ipexport.sh
    source ~/ros-workspaces/elikos-ws/devel/setup.bash
    #roslaunch elikos_ros elikos_px4.launch &
# Arrêt des processus.
elif [ "$STOP" = true ] ; then
    echo 'Arrêt des processus!'
    killall vicon_bridge
    killall static_transform_publisher
    killall elikos_origin_init
    killall mavros_node
# Initialisation d''elikos_arena_origin.
elif [ "$ORIGIN_INIT" = true ] ; then
    echo 'Initialisation d''elikos_arena_origin!'
    rosservice call /elikos_origin_init
fi
if [ "$STATIC_TRANSFORM" = true ] ; then
    echo 'Transformation statique!'
    echo "$X" "$Y" "$Z"
    rosrun tf static_transform_publisher "$X" "$Y" "$Z" 0 0 0 1 elikos_arena_origin elikos_vision 100 &
fi