#!/bin/bash

. ./config.sh
cuda_dev=$cuda_1061
worker_name=EVGA61

echo -ne "\033]0;"XVG HashFaster Lyra CUDA $cuda_dev"\007"

cd $path_ccminer

if ![[ $cuda_dev =~ ^[0-9]+$ ]] ; then
      echo "device_cuda is NA or is not a number: $cuda_dev"
   read toto
   exit 1
fi

./ccminer -a lyra2v2 -o stratum+tcp://hashfaster.com:3740 -u DLEkrbw8HHySKiWrY47yR89idCSzn7BBGi -d $cuda_dev 

