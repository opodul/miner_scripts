#!/bin/bash

. ./config.sh
cuda_dev=$cuda_1062
worker_name=EVGA62

echo -ne "\033]0;"Dwarfpool ETH CUDA $cuda_dev"\007"

cd $path_ethminer

if ![[ $cuda_dev =~ ^[0-9]+$ ]] ; then
      echo "device_cuda is NA or is not a number: $cuda_dev"
   read toto
   exit 1
fi

./ethminer -U -F http://eth-eu.dwarfpool.com:80/$account_ETH/$worker_name -HWMON --cuda-devices $cuda_dev
