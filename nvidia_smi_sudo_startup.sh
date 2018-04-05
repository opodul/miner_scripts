#!/bin/bash

#make sure to execute this @startup with sudo right 
# cf /etc/rc.local

#GTX 1050
sudo nvidia-smi -i 0 -pl 75
#GTX 1060 #1
sudo nvidia-smi -i 1 -pl 73
#GTX 1060 #2
sudo nvidia-smi -i 2 -pl 72
#GTX 1070
sudo nvidia-smi -i 3 -pl 93
