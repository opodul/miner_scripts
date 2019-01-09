#!/bin/bash

. ./config.sh
cuda_dev=$cuda_1062
worker_name=EVGA62

echo -ne "\033]0;"ZEN suprnova CUDA $cuda_dev"\007"

cd $path_ccminer
#cd $path_suprminer

if ![[ $cuda_dev =~ ^[0-9]+$ ]] ; then
      echo "device_cuda is NA or is not a number: $cuda_dev"
   read toto
   exit 1
fi

./ccminer -a equihash -o stratum+tcp://zen.suprnova.cc:3620 -u $suprnova_weblogin.$worker_name -p $suprnova_pass -d $cuda_dev

