#!/bin/bash

param_task=$1
param_pos=$2

log_file=./log/log_v3_$param_task.txt

time_dead=3

#advive to set about 12000 max. in my case 15000 seconds leads to blackscreen miner stop, reason = unknow.
time_life_min=9999
time_life_jitter=888

# random delay at startup
# tmp=$(od -An -N4 -tu /dev/urandom)
# tmp=$(( $tmp % 20 ))
# sleep $tmp

echo "param_task=[$param_task]"
echo "param_pos=[$param_pos]"

# Handle different position of the terminal

## declare interger for math calculation
declare -i x_start
declare -i y_start
declare -i x_shift
declare -i y_shift
declare -i x_pos
declare -i y_pos
declare -i x_terminal
declare -i y_terminal

## fixed parameters


#x_window=105 #normal
x_window=120 #wide
y_window=22
x_start=0
y_start=50
#x_shift=640 #normal
x_shift=750 #wide
y_shift=400

## set x_pos and y_pos according pos0..5 etc.

if [ "$param_pos" = "pos0" ] ; then
   x_pos=0; y_pos=0; time_life_drift=0
elif [ "$param_pos" = "pos1" ] ; then
   x_pos=1; y_pos=0; time_life_drift=4
elif [ "$param_pos" = "pos2" ] ; then
   x_pos=2; y_pos=0; time_life_drift=8
elif [ "$param_pos" = "pos3" ] ; then
   x_pos=0; y_pos=1; time_life_drift=12
elif [ "$param_pos" = "pos4" ] ; then
   x_pos=1; y_pos=1; time_life_drift=16
else
   x_pos=2; y_pos=1; time_life_drift=20
fi

## calc terminal position
x_terminal=$x_abs+$x_shift*$x_pos
y_terminal=$y_abs+$y_shift*$y_pos

## create string for task start includint the terminal position ans size
start_task="xterm -geometry ${x_window}x${y_window}+${x_terminal}+${y_terminal} -e ./$param_task &"

## create string for task killing
stop_task="pkill -f ./$param_task"

sleep $time_life_drift

time_life_min=$(( $time_life_min + $time_life_drift ))

# infinite loop
while [ 1 ]
do

   #read 32 bits from urandom and make it between time_life_min and time_life_min+time_life_jitter
   tmp=$(od -An -N4 -tu /dev/urandom)
   time_life=$(( ($tmp % ($time_life_jitter))+$time_life_min ))

   # kill and restart task
   echo $(date '+%Y %b %d %H:%M:%S') 'stop&restart:' $param_task " for $time_life sec."| tee -a $log_file

   while pgrep steam; do # do not restart the task when I am playing !!
      sleep 60 
   done

   eval $stop_task
   sleep $time_dead

   eval $start_task
   sleep $time_life
  
done # while :



