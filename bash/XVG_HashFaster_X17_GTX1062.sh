#!/bin/bash

. ./config.sh
cuda_dev=$cuda_1062
worker_name=EVGA62

echo -ne "\033]0;"XVG HashFaster X17 CUDA $cuda_dev"\007"

cd $path_ccminer

if ![[ $cuda_dev =~ ^[0-9]+$ ]] ; then
      echo "device_cuda is NA or is not a number: $cuda_dev"
   read toto
   exit 1
fi

./ccminer -a x17 -o stratum+tcp://hashfaster.com:3737 -u DNhUfkBweA4omWxGUMZqKqooJsP8zVL44h -d $cuda_dev 

