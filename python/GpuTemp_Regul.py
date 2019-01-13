#!/usr/bin/env python3
import os
import re
import time
import math
import json

#--------------------------
# module variable
KP_UP=15.0
KP_DOWN=0
TEMP_KP_OFFSET=2.0

KI_UP=0.2
KI_DOWN=KI_UP/5.0
TEMP_TARGET=71.0
TEMP_TARGET_MIN=TEMP_TARGET-15.0

GPUFREQ_MIN=500

g_NbGpu=0;
g_RegulInfo_Ipart=[]
g_RegulInfo_Fixpart=[]
g_RegulInfo_OkCnt=[]
g_RegulInfo_OkPwm=[]
g_RegulInfo_GpuTemp=[]
g_RegulInfo_GpuFreq=[]

#--------------------------
def get_AllGpuTemp():
    cmd="nvidia-settings -q [gpu]/GPUCoreTemp"
    lines=os.popen(cmd).readlines()
    
    temp=[]
    for line in lines:
        m=re.search('Attribute.*gpu:([0-9]).* ([0-9]+)\.', line)
        if m is not None:
            #dbg: print(line)
            #todo: gpu_idx=int(m.group(1)) # gpu index is not verified, we assume to get those in the correct order
            gpu_temp= float(m.group(2))
            temp.append(gpu_temp)
    return temp
    
#--------------------------
def get_AllGpuFreq():
    cmd="nvidia-settings -q [gpu]/GPUCurrentClockFreqs"
    lines=os.popen(cmd).readlines()
    
    freq=[]
    for line in lines:
        m=re.search('Attribute.*gpu:([0-9]).* ([0-9]+),([0-9]+)\.', line)
        if m is not None:
            #dbg: print(line)
            #todo: gpu_idx=int(m.group(1)) # gpu index is not verified, we assume to get those in the correct order
            gpu_freq= float(m.group(2))
            #m.group(3) is the memory freq
            freq.append(gpu_freq)
    return freq
    
#-------------------------- 
def set_FanSpeedAuto( index=0 ): 
    cmd ="nvidia-settings -a [gpu:"+str(int(index))+"]/GPUFanControlState=0"
    os.popen(cmd)
    return
    
#-------------------------- 
def set_FanSpeed( index=0 , pwm=95 ):
    cmd ="nvidia-settings"
    cmd+=" -a [gpu:"+str(int(index))+"]/GPUFanControlState=1"
    cmd+=" -a [fan:"+str(int(index))+"]/GPUTargetFanSpeed="+str(int(pwm))
    os.popen(cmd)
    #print(cmd)
    return

#-------------------------- 
def write_AllFanSpeed( values ): 
    with open("fanSpeed.json","w") as f:
        json.dump(values,f)
    return
    
#--------------------------  
def read_AllFanSpeed( ): 
    try:
        with open("fanSpeed.json","r") as f:
            values = json.load(f)
    except IOError:
        values=[50.0, 50.0, 50.0, 50.0]
    return values
    
#-------------------------- 
def Regul_Loop(index=0):

    global g_RegulInfo_GpuFreq  
    global g_RegulInfo_OkCnt  
    
    temp_curr=g_RegulInfo_GpuTemp[index]
    temp_diff=temp_curr-TEMP_TARGET
    
    #set default value
    pwm_val = g_RegulInfo_Fixpart[index]   
    
    #temperature low enough --> shut off the fan
    if temp_curr < TEMP_TARGET_MIN:
        pwm_val = 5
   
    #no GPU activity --> shut off the fan
    elif g_RegulInfo_GpuFreq[index] < GPUFREQ_MIN and temp_curr < TEMP_TARGET:
        pwm_val = 4
        
    #temparature higher than target
    elif 0 < temp_diff:
        g_RegulInfo_Ipart[index]+=temp_diff*KI_UP
        if 50.0 < g_RegulInfo_Ipart[index]:
            g_RegulInfo_Ipart[index] = 50.0
        
        pwm_val+=g_RegulInfo_Ipart[index] 
        
        #KP is active only if Temperature is much higher
        temp_diff_KP = temp_diff - TEMP_KP_OFFSET
        if 0 < temp_diff_KP:
            pwm_val += KP_UP*temp_diff_KP
            
    #temparature lower than target
    else:
        g_RegulInfo_Ipart[index]+=temp_diff*KI_DOWN
        if g_RegulInfo_Ipart[index] < -50.0:
            g_RegulInfo_Ipart[index] = -50.0
            
        pwm_val+=g_RegulInfo_Ipart[index] 
       
    if 95.0 < pwm_val :
        pwm_val = 95.0
        g_RegulInfo_OkCnt[index]=0
    elif pwm_val < 4.0:
        pwm_val = 4.0
        g_RegulInfo_OkCnt[index]=0
    elif abs(temp_diff) > 1 :
        g_RegulInfo_OkCnt[index]=0
    else:
        g_RegulInfo_OkCnt[index]+=1
        if 127==(g_RegulInfo_OkCnt[index] % 128):
            g_RegulInfo_OkPwm[index] = math.ceil(pwm_val) 
            write_AllFanSpeed(g_RegulInfo_OkPwm)

    msg  = "%d: °C curr:%3.1f   " % (index,temp_curr)
    msg += "°C diff:%+3.1f   " % (temp_diff)
    msg += "pwm:%5.2f   " % (pwm_val)
    msg += "OkCnt:%3d" % (g_RegulInfo_OkCnt[index])
    print(msg)
    
    set_FanSpeed(int(pwm_val) , index)
    
    with open("out"+str(index)+".csv","a") as f:
        f.write(str(int(time.time()))+";"+str(temp_curr)+";"+str(pwm_val)+"\n")
    
    return

#--------------------------

def init():

    global g_RegulInfo_Ipart
    global g_RegulInfo_Fixpart
    global g_RegulInfo_OkCnt
    global g_RegulInfo_OkPwm
    global g_NbGpu

    g_RegulInfo_OkPwm = g_RegulInfo_Fixpart = read_AllFanSpeed()
    g_NbGpu=g_RegulInfo_Fixpart.__len__()
    
    if 0 == g_NbGpu:
        return -1
       
    for i in range(g_NbGpu):
        i=i #ignore warning unused
        g_RegulInfo_OkCnt.append(0)
        g_RegulInfo_Ipart.append(0.0)
        
    return 0
    
def loop():
    
    global g_RegulInfo_GpuTemp
    global g_RegulInfo_GpuFreq
    
    g_RegulInfo_GpuTemp=get_AllGpuTemp()
    g_RegulInfo_GpuFreq=get_AllGpuFreq()

    for i in range(g_NbGpu):
        Regul_Loop(i)        
    return 
        
def main():

    if( init() != 0 ):
        return -1
        
    while 1:
        loop_time=15
        wait_time=loop_time - (time.time() % loop_time)
        print("wait for %5.2f sec" % (wait_time) )
        time.sleep(wait_time)
        loop()
        
    for i in range(g_NbGpu):
        set_FanSpeedAuto(i)
    return


if __name__ == "__main__":
    main()






