#!/bin/bash

. ./config.sh
cuda_dev=$cuda_1061
worker_name=EVGA61

echo -ne "\033]0;"MinerGate ETH CUDA $cuda_dev"\007"

cd $path_ethminer

if ![[ $cuda_dev =~ ^[0-9]+$ ]] ; then
      echo "device_cuda is NA or is not a number: $cuda_dev"
   read toto
   exit 1
fi

./ethminer -U -S eth.pool.minergate.com:45791 -u $account_minergate -HWMON --cuda-devices $cuda_dev
