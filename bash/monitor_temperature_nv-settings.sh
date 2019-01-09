#!/bin/bash



param_device=$1
param_task=$2

log_file=./log/log_temp_$param_device.txt

# lower temperature for CPU than GPU
if [ "$param_device" = "CPU" ] ; then
   temp_alert=60
   temp_panic=70
else
   temp_alert=75
   temp_panic=80
fi

if [ "$param_device" = "GTX1051" ] ; then
   #get GTX1050 temperature
   gpu=0
   get_temp="nvidia-settings -q "[gpu:${gpu}]/GPUCoreTemp" | grep gpu:${gpu} | perl -nle 'm/ ([0-9]+)\.$/; print \$1'"
elif [ "$param_device" = "GTX1061" ] ; then
   #get GTX1050 temperature
   gpu=1
   get_temp="nvidia-settings -q "[gpu:${gpu}]/GPUCoreTemp" | grep gpu:${gpu} | perl -nle 'm/ ([0-9]+)\.$/; print \$1'"
elif [ "$param_device" = "GTX1062" ] ; then
   #get GTX1050 temperature
   gpu=2
   get_temp="nvidia-settings -q "[gpu:${gpu}]/GPUCoreTemp" | grep gpu:${gpu} | perl -nle 'm/ ([0-9]+)\.$/; print \$1'"
elif [ "$param_device" = "GTX1071" ] ; then
   #get GTX1050 temperature
   gpu=3
   get_temp="nvidia-settings -q "[gpu:${gpu}]/GPUCoreTemp" | grep gpu:${gpu} | perl -nle 'm/ ([0-9]+)\.$/; print \$1'"
else
   echo "0"
fi


# infinite loop
while [ 1 ]
do

   for i in `seq 0 3600`; do
      
      temperature=$(eval $get_temp)
      
      if [ `expr $i % 600` -eq 0 ] ; then   #log temprature once a while
         echo $(date '+%Y %b %d %H:%M:%S') " Device:$param_device=$temperature°C" | tee -a $log_file
      elif [ `expr $i % 180` -eq 0 ] ; then
         echo $(date '+%Y %b %d %H:%M:%S') " Device:$param_device=$temperature°C"
      fi

      #ALARM Overtemperature protection --> shutdown the complete PC !!
      if [ $temperature -gt $temp_panic ] ; then
         echo $(date '+%Y %b %d %H:%M:%S') " PANIC shutdown because $param_device=$temperature°C" | tee -a $log_file
         shutdown -h now
      fi

      #ALERT Overtemperature protection --> kill the task (will be restart at next while loop)
      if [ $temperature -gt $temp_alert ] ; then
         echo $(date '+%Y %b %d %H:%M:%S') " ALERT killing task [$param_task] because $param_device=$temperature°C" | tee -a $log_file
         pkill -f $param_task
      fi
 
      sleep 1
   done # for
done # while



