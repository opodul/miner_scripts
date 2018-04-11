#!/bin/bash

echo -ne "\033]0;"Miner scheduler\/monitor, at any time Type \"quit\" to quit  "\007"

cd ~/miner/miner_scripts

./nvidia_settings_mining.sh

if [ "$Mode" = "" ] ; then
#Mode=UBQ
#Mode=ETH_M
#Mode=ETH_D
#Mode=DUMMY
#Mode=MIXED
#Mode=XVG
Mode=XVG_compare
fi

if [ "$Mode" = "UBQ" ] ; then
   task1051=UBQ_baleine_GTX1051.sh
   task1061=UBQ_baleine_GTX1061.sh
   task1062=UBQ_baleine_GTX1062.sh
   task1071=UBQ_baleine_GTX1071.sh
elif [ "$Mode" = "ETH_D" ] ; then
   task1051=ETH_dwarf_GTX1051.sh
   task1061=ETH_dwarf_GTX1061.sh
   task1062=ETH_dwarf_GTX1062.sh
   task1071=ETH_dwarf_GTX1071.sh
elif [ "$Mode" = "ETH_M" ] ; then
   task1051=ETH_minergate_GTX1051.sh
   task1061=ETH_minergate_GTX1061.sh
   task1062=ETH_minergate_GTX1062.sh
   task1071=ETH_minergate_GTX1071.sh
elif [ "$Mode" = "MIXED" ] ; then
   task1051=UBQ_baleine_GTX1051.sh
   task1061=ETH_dwarf_GTX1061.sh
   task1062=ETH_dwarf_GTX1062.sh
   task1071=UBQ_baleine_GTX1071.sh
elif [ "$Mode" = "XVG" ] ; then
# XVG on 1051 always crash --> mine somzthing else instead
   #task1051=UBQ_baleine_GTX1051.sh 
   task1051=ETH_dwarf_GTX1051.sh 
   task1061=XVG_yiimp_GTX1061.sh
   task1062=XVG_yiimp_GTX1062.sh
   task1071=XVG_yiimp_GTX1071.sh
elif [ "$Mode" = "XVG_compare" ] ; then
# XVG on 1051 always crash --> mine somzthing else instead
   task1051=UBQ_baleine_GTX1051.sh 
   task1061=XVG_HashFaster_Lyra_GTX1061.sh
   task1062=XVG_HashFaster_X17_GTX1062.sh
   task1071=ETH_dwarf_GTX1071.sh
else
   task1051=dummy_task0.sh
   task1061=dummy_task1.sh
   task1062=dummy_task2.sh
   task1063=dummy_task3.sh
fi

task_CPU0=XMR_minergate_4.sh
task_CPU1=XMR_minergate_2.sh


./scheduler.sh $task1071 pos0 &
./scheduler.sh $task1061 pos1 &
./scheduler.sh $task1062 pos3 &
./scheduler.sh $task1051 pos4 &
#./scheduler_v3.sh $task_CPU0 pos4 &
#./scheduler_v3.sh $task_CPU1 pos5 &

# any shell matching the patter .*_GTX1051.sh will be killed in case of overtemperature
./monitor_temperature_nv-settings.sh GTX1051 _GTX1051.sh &
./monitor_temperature_nv-settings.sh GTX1061 _GTX1061.sh &
./monitor_temperature_nv-settings.sh GTX1062 _GTX1062.sh &
./monitor_temperature_nv-settings.sh GTX1071 _GTX1071.sh &

#./monitor_temperature.sh CPU $task_CPU0 &
#./monitor_temperature.sh CPU $task_CPU1 &

while [ 1 ]
do
   echo "Type 'quit' to quit"
   read -t 50 key

   if [ "$key" = "quit" ]
   then
      pkill -f scheduler.sh
      pkill -f monitor_temperature
      pkill -f ethminer
      pkill -f XMR_minergate
      ./nvidia_settings_default.sh
      exit
   fi
done



