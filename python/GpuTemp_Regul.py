#!/usr/bin/env python3
import os
import re
import time
import math
#import threading, subprocess, signal

#--------------------------
# module variable
KP_UP=15.0
KP_DOWN=0
TEMP_KP_OFFSET=2.0

KI_UP=0.2
KI_DOWN=KI_UP/5.0
TEMP_TARGET=71.0
TEMP_DIFF_MIN=-15.0

GPUFREQ_MIN=500

#--------------------------
def get_GpuTemp( index=0 ):
    cmd="nvidia-settings -q [gpu:"+str(index)+"]/GPUCoreTemp | grep gpu:"+str(index)
    o=os.popen(cmd).read()
    m=re.search('([0-9]+)\.$', o)
    if m is not None:
        temp=float( m.group(1) )
    else:
        temp=99.0
        
    return temp
    
#--------------------------
def get_GpuFreq( index=0 ):
    cmd ="nvidia-settings -q [gpu:"+str(int(index))+"]/GPUCurrentClockFreqs"
    cmd+=" |grep gpu:"+str(int(index))
    o=os.popen(cmd).read()
    m=re.search('([0-9]+),([0-9]+)\.$', o)
    if m is not None:
        freq1=float( m.group(1) )
    else:
        freq1=9999.0
        
    return freq1
    
#-------------------------- 
def set_FanSpeedAuto( index=0 ): 
    cmd ="nvidia-settings -a [gpu:"+str(int(index))+"]/GPUFanControlState=0"
    os.popen(cmd)
    return
  
#-------------------------- 
def set_FanSpeedManu( index=0 ): 
    cmd ="nvidia-settings -a [gpu:"+str(int(index))+"]/GPUFanControlState=1"
    os.popen(cmd)
    return
    
#-------------------------- 
def set_FanSpeedValue( value=80 ,index=0 ):
    cmd ="nvidia-settings -a [fan:"+str(int(index))+"]/GPUTargetFanSpeed="+str(int(value))
    os.popen(cmd)
    return

#-------------------------- 
def write_FanSpeed( value , index=0,  ): 
    with open("fan"+str(index)+".cfg","w") as f:
        f.write(str(value))
    return
    
#--------------------------  
def read_FanSpeed( index=0 ): 
    try:
        with open("fan"+str(index)+".cfg","r") as f:
            value=float(f.read())
    except IOError:
        value=50.0
    return value
    
#-------------------------- 
def Regul_Loop(index=0):
    temp_curr=get_GpuTemp(index)
    temp_diff=temp_curr-TEMP_TARGET
    
    #set default value
    pwm_val = Regul_Loop.Fixpart[index]   
    
    #temperature low enough --> shut off the fan
    if temp_diff < TEMP_DIFF_MIN:
        pwm_val = 5
   
    #no GPU activity --> shut off the fan
    elif get_GpuFreq(index) < GPUFREQ_MIN:
        pwm_val = 4
        
    #temparature higher than target
    elif 0 < temp_diff:
        Regul_Loop.Ipart[index]+=temp_diff*KI_UP
        if 30.0 < Regul_Loop.Ipart[index]:
            Regul_Loop.Ipart[index] = 30.0
        
        pwm_val+=Regul_Loop.Ipart[index] 
        
        #KP is active only if Temperature is much higher
        temp_diff_KP = temp_diff - TEMP_KP_OFFSET
        if 0 < temp_diff_KP:
            pwm_val += KP_UP*temp_diff_KP
            
    #temparature lower than target
    else:
        Regul_Loop.Ipart[index]+=temp_diff*KI_DOWN
        if Regul_Loop.Ipart[index] < -20.0:
            Regul_Loop.Ipart[index] = -20.0
            
        pwm_val+=Regul_Loop.Ipart[index] 
       
    if 95.0 < pwm_val :
        pwm_val = 95.0
        Regul_Loop.OkCnt[index]=0
    elif pwm_val < 4.0:
        pwm_val = 4.0
        Regul_Loop.OkCnt[index]=0
    elif abs(temp_diff) > 1 :
        Regul_Loop.OkCnt[index]=0
    else:
        Regul_Loop.OkCnt[index]+=1
        if 0==(Regul_Loop.OkCnt[index] % 128):
            write_FanSpeed( math.ceil(pwm_val) , index )

    msg  = "%d: °C curr:%3.1f   " % (index,temp_curr)
    msg += "°C diff:%+3.1f   " % (temp_diff)
    msg += "pwm:%5.2f   " % (pwm_val)
    msg += "OkCnt:%3d" % (Regul_Loop.OkCnt[index])
    print(msg)
    
    set_FanSpeedValue(int(pwm_val) , index)
    
    with open("out"+str(index)+".csv","a") as f:
        f.write(str(int(time.time()))+";"+str(temp_curr)+";"+str(pwm_val)+"\n")
    
    return

#--------------------------
def main():
    #print( get_GpuTemp(0) )
    #print( get_GpuTemp(1) )
    #print( get_GpuTemp(2) )
    #print( get_GpuTemp(3) )
    
    #print( get_GpuFreq(0) )
    #print( get_GpuFreq(1) )
    #print( get_GpuFreq(2) )
    #print( get_GpuFreq(3) )
    
    #set_FanSpeedValue(38.3 , 1)
    
    set_FanSpeedManu( 0 )
    set_FanSpeedManu( 1 )
    set_FanSpeedManu( 2 )
    set_FanSpeedManu( 3 )
    
    print( math.ceil(1.55) )
    
    while 1:
        loop_time=15
        wait_time=loop_time - (time.time() % loop_time)
        print("wait for %5.2f sec" % (wait_time) )
        time.sleep(wait_time)
        Regul_Loop(0)
        Regul_Loop(1)
        Regul_Loop(2)
        Regul_Loop(3)
    return


if __name__ == "__main__":
    Regul_Loop.Ipart=[ 0.0 , 0.0 , 0.0 , 0.0 ]
    Regul_Loop.Fixpart=[ read_FanSpeed(0) , read_FanSpeed(1) ,
                         read_FanSpeed(2) , read_FanSpeed(3) ]
    Regul_Loop.OkCnt=[ 0 , 0 , 0 , 0 ]
    main()






