# Valeurs par défauts
TEST_DECOLLAGE=false
TEST_L=false

# Extraction des paramètres
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    test-decollage)
    TEST_DECOLLAGE=true
    shift
    ;;
    test-L)
    TEST_L=true
    shift
    ;;
    *)
    ;;
esac
shift
done

# Test de decollage
if [ "$TEST_DECOLLAGE" = true ] ; then
    echo 'Test de decollage!'
    ./commandes_elikos2018.sh start-nav &
    sleep 5s
    ./commandes_elikos2018.sh setpoint 0 0 1.5 &
    sleep 45s
    ./commandes_elikos2018.sh land
    sleep 30s
    ./commandes_elikos2018.sh stop
fi

# Test L
if [ "$TEST_L" = true ] ; then
    echo 'Test de decollage!'
    ./commandes_elikos2018.sh start-nav &
    sleep 5s
    ./commandes_elikos2018.sh setpoint 0 0 1.5 &
    sleep 30s
    ./commandes_elikos2018.sh kill-setpoint &
    ./commandes_elikos2018.sh setpoint 2 0 1.5 &
    sleep 30s
    ./commandes_elikos2018.sh kill-setpoint &
    ./commandes_elikos2018.sh setpoint 2 1 1.5 &
    sleep 30s
    ./commandes_elikos2018.sh land
    sleep 30s
    ./commandes_elikos2018.sh stop
fi