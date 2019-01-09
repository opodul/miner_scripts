#!/bin/bash

. ./config.sh
cuda_dev=$cuda_1062
worker_name=EVGA62

echo -ne "\033]0;"XVG yiimp CUDA $cuda_dev"\007"

cd $path_ccminer

if ![[ $cuda_dev =~ ^[0-9]+$ ]] ; then
      echo "device_cuda is NA or is not a number: $cuda_dev"
   read toto
   exit 1
fi

# use port 3737 the others use 3777
./ccminer -a x17 -o stratum+tcp://yiimp.eu:3737 -u $account_XVG -p c=XVG -d $cuda_dev


