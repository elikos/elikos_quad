#!/bin/bash

path=$(dirname "$0")
cd $path
echo -e "tone_alarm MFL8CEG4\n" | ./px4_nsh.sh > bootlog.log

