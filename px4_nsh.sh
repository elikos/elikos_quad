#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
nc -z localhost 5760 
if [ $? = 0 ]
then
  echo "Using proxy to connect to PixHawk"
  CON_NUM=$(netstat -anp 2> /dev/null | grep :5760 | grep ESTABLISHED | wc -l ) # | tr -d '\n')
  echo "'${CON_NUM}' connections"
  if [ "${CON_NUM}" == "0" ]
  then
    echo "Connecting to mavros"
    ~/Firmware/Tools/mavlink_shell.py tcp:localhost:5760
  else
    echo "Other connection detected. Starting secondary proxy."
    source "${DIR}/driver-ws/devel/setup.bash"
    rosrun mavros gcs_bridge _gcs_url:='tcp-l://0.0.0.0:5761' &
    ~/Firmware/Tools/mavlink_shell.py tcp:localhost:5761
  fi
else
  echo "Connecting directly to ttyUSB0"
  ~/Firmware/Tools/mavlink_shell.py --baudrate 921600 /dev/ttyUSB0
fi

