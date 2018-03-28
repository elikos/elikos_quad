# Valeurs par défauts
SETPOINT=false
KILLSETPOINT=false
STARTNAV=false
STOP=false
LAND=false
X=0
Y=0
Z=2

# Extraction des paramètres
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    start-nav)
    STARTNAV=true
    STOP=false
    shift
    ;;
    setpoint)
    SETPOINT=true
    X="$2"
    Y="$3"
    Z="$4"
    shift
    ;;
    kill-setpoint)
    KILLSETPOINT=true
    shift
    ;;
    stop)
    STOP=true
    shift
    ;;
    land)
    LAND=true
    shift
    ;;
    *)
    ;;
esac
shift
done

# Demarrage des processus
if [ "$STARTNAV" = true ] ; then
    echo 'Demarrage des processus!'
    source ~/elikos_quad/elikos-ws/devel/setup.bash 
    roslaunch elikos_main elikos_test_zr300.launch

# Lancement d'un setpoint static.
elif [ "$SETPOINT" = true ] ; then
    echo 'SETPOINT statique!'
    rosrun tf static_transform_publisher "$X" "$Y" "$Z" 0 0 0 1 elikos_local_origin elikos_setpoint 100 > /dev/null &

# Arrêt du setpoint.
elif [ "$KILLSETPOINT" = true ] ; then
    echo 'Arrêt des setpoints!'
    killall static_transform_publisher

# Arrêt des processus.
elif [ "$STOP" = true ] ; then
    echo 'Arrêt des processus!'
    rosnode kill -a

# Atterrissage.
elif [ "$LAND" = true ] ; then
    echo 'Atterrissage!'
    rosservice call /mavros/cmd/land "{min_pitch: 0.0, yaw: 0.0, latitude: 0.0, longitude: 0.0, altitude: 0.0}"
fi