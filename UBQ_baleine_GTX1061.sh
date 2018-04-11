#!/bin/bash

. ./config.sh
cuda_dev=$cuda_1061
worker_name=EVGA61

echo -ne "\033]0;"Baleine UBQ CUDA $cuda_dev"\007"

cd $path_ethminer

if ![[ $cuda_dev =~ ^[0-9]+$ ]] ; then
      echo "device_cuda is NA or is not a number: $cuda_dev"
   read toto
   exit 1
fi

./ethminer --farm-recheck 200 -U -S mine.ubq.mining-pool.fr:8088 -SP 1 -O $account_UBQ.$worker_name -HWMON --cuda-devices $cuda_dev
