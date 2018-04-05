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

if [ "$param_device" = "GTX1050" ] ; then
   #get GTX1070 temperature (using the memory size to catch the corresponding line)
   get_temp="nvidia-smi | grep 4038MiB | perl -nle 'm/ ([0-9]*)C/; print \$1'"
elif [ "$param_device" = "GTX1060" ] ; then
   #get GTX1060 temperature (using the memory size to catch the corresponding line)
   get_temp="nvidia-smi | grep 6072MiB | perl -nle 'm/ ([0-9]*)C/; print \$1'"
elif [ "$param_device" = "GTX1070" ] ; then
   #get GTX1050Ti temperature (using the memory size to catch the corresponding line)
   get_temp="nvidia-smi | grep 8110MiB | perl -nle 'm/ ([0-9]*)C/; print \$1'"
elif [ "$param_device" = "CPU" ] ; then
   #get CPU temperature (get integer value only)
   get_temp="sensors | grep CPUTIN | perl -nle 'm/\+([0-9]*).[0-9]°C/; print \$1'"
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



