#!/bin/bash

i=3
	nvidia-settings -a "[gpu:${i}]/GPUFanControlState=0"> /dev/null
	nvidia-settings -a "[gpu:${i}]/GPUPowerMizerMode=2"> /dev/null
	nvidia-settings -a "[gpu:${i}]/GPUGraphicsClockOffset[2]=0"> /dev/null
	nvidia-settings -a "[gpu:${i}]/GPUGraphicsClockOffset[3]=0"> /dev/null
	nvidia-settings -a "[gpu:${i}]/GPUMemoryTransferRateOffset[2]=0"> /dev/null
	nvidia-settings -a "[gpu:${i}]/GPUMemoryTransferRateOffset[3]=0"> /dev/null

	echo "[gpu:${i}] Set FanControlState=0 + ResetAll ClockOffet to 0"

exit 0
