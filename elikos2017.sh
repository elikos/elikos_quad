
# Valeurs par défauts
START=true
STOP=false
VICON=false
STATIC_TRANSFORM=false
ORIGIN_INIT=false
SETPOINT=false
VIS_AI=false
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
    init)
    ORIGIN_INIT=true
    START=false
    STOP=false
    VICON=false
    shift
    ;;
    vis-ai)
    VIS_AI=true
    START=false
    STOP=false
    VICON=false
    shift
    ;;
    setpoint)
    SETPOINT=true
    START=false
    STOP=false
    X="$2"
    Y="$3"
    Z="$4"
    shift
    ;;
    *)
    ;;
esac
shift
done

# Lancement d'un setpoint static.
if [ "$SETPOINT" = true ] ; then
    echo 'SETPOINT statique!'
    killall static_transform_publisher
    rosrun tf static_transform_publisher "$X" "$Y" "$Z" 0 0 0 1 elikos_arena_origin elikos_setpoint 100 > /dev/null &
    sleep 2
fi
# Démarrage des processus.
if [ "$START" = true ] ; then
    echo 'Démarrage des processus!'
    roscore > /dev/null &
    sleep 2
# Démarrage de vicon_bridge.
if [ "$VICON" = true ] ; then
    echo 'Démarrage de vicon_bridge!'
    source ~/elikos_quad/elikos-ws/devel/setup.bash
    roslaunch elikos_vicon_remapping elikos_vicon_remapping.launch > /dev/null &
    sleep 2
fi
if [ "$STATIC_TRANSFORM" = true ] ; then
    echo 'Transformation statique!'
    rosrun tf static_transform_publisher "$X" "$Y" "$Z" 0 0 0 1 elikos_arena_origin elikos_vision 100 > /dev/null &
    sleep 2
fi
    source ~/elikos_quad/ipexport.sh
    source ~/elikos_quad/elikos-ws/devel/setup.bash
    echo 'Launch de mavros et d elikos_origin_init'
    ./elikos_cameras.sh start
    sleep 1
    #roslaunch elikos_ros elikos_ai_control.launch > /dev/null &
    #roslaunch elikos_localization localization.launch &
    roslaunch elikos_ros elikos_multi_cameras.launch > /dev/null &
    echo 'Localisation et controle lance'
    roslaunch elikos_ros elikos_px4.launch > /dev/null &
    sleep 2 
    roslaunch elikos_ros elikos_transformations.launch &> /dev/null &
# Arrêt des processus.
elif [ "$STOP" = true ] ; then
    echo 'Arrêt des processus!'
    killall vicon_bridge
    killall static_transform_publisher
    killall elikos_origin_init
    killall mavros_node
    killall roscore
    ./elikos_cameras.sh stop
# Initialisation d''elikos_arena_origin.
elif [ "$ORIGIN_INIT" = true ] ; then
    echo 'Initialisation d''elikos_arena_origin!'
    rosservice call --wait /elikos_origin_init  > /dev/null 
    echo 'elikos_arena_origin initialisé :)'
elif [ "$VIS_AI" = true ] ; then
    echo "Launch de la vision et de l'AI :p"
    source ~/elikos_quad/elikos-ws/devel/setup.bash
    roslaunch elikos_localization localization.launch > /dev/null &
    sleep 2
    roslaunch elikos_ros elikos_ai_control.launch > /dev/null &
    echo "Vision et AI lancé"
fi
