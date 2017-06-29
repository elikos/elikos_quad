#!/bin/bash

# Valeurs par défauts
START=true
STOP=false

# Extraction des paramètres
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    start)
    START=true
    STOP=false
    shift
    ;;
    stop)
    START=false
    STOP=true
    shift
    ;;
    *)
    ;;
esac
shift
done

# Démarrage des processus.
if [ "$START" = true ] ; then
    echo 'Démarrage des processus!'
    source ~/elikos_quad/elikos-ws/devel/setup.bash
    roslaunch elikos_ros elikos_realsense_left.launch > /dev/null &
    sleep 2
    roslaunch elikos_ros elikos_realsense_right.launch > /dev/null &
    sleep 2
    roslaunch elikos_ros elikos_realsense_front.launch > /dev/null &
    sleep 2
    roslaunch elikos_ros elikos_realsense_back.launch > /dev/null &
    sleep 2
    roslaunch elikos_ros elikos_pointgrey_bottom.launch > /dev/null &
    sleep 2
# Arrêt des processus.
elif [ "$STOP" = true ] ; then
    echo 'Arrêt des processus!'
    killall roslaunch
fi
