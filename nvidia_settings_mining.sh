#!/bin/bash


#GPUPowerMizerMode
# 2 = auto
# 1 = perf

for i in `seq 0 3`
do
	nvidia-settings -a "[gpu:${i}]/GPUFanControlState=1" -a "[fan:${i}]/GPUTargetFanSpeed=50" >/dev/null
	nvidia-settings -a "[gpu:${i}]/GPUPowerMizerMode=2">/dev/null
	nvidia-settings -a "[gpu:${i}]/GPUGraphicsClockOffset[2]=-200">/dev/null
	nvidia-settings -a "[gpu:${i}]/GPUGraphicsClockOffset[3]=-200">/dev/null
	nvidia-settings -a "[gpu:${i}]/GPUMemoryTransferRateOffset[2]=400">/dev/null
	nvidia-settings -a "[gpu:${i}]/GPUMemoryTransferRateOffset[3]=400">/dev/null

	echo "[gpu:${i}] Set FanControlState=1 (Fan to 50%) + ClockOffet to (-200;+400)"
done

nvidia-settings -a "[gpu:0]/GPUMemoryTransferRateOffset[2]=50">/dev/null
nvidia-settings -a "[gpu:0]/GPUMemoryTransferRateOffset[3]=50">/dev/null

#put specific value for each GPU
#1050
nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=45"
#1060
nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=57"
#1060 SC
nvidia-settings -a "[fan:2]/GPUTargetFanSpeed=35"
#1070
nvidia-settings -a "[fan:3]/GPUTargetFanSpeed=30"

exit 0
