#!/bin/bash

#Generates audio notification when CPU load average is above 90%

sleep 30 #To allow boot process to complete. CPU load will be high initially.

while true
do
    list=`cat /proc/loadavg`
    set -- $list
    load=$1 #Set 1 minute cpu load
    load=`echo "scale=2; $load * 100" | bc` #Convert to integer
    load=`printf "%.0f" $load` #Remove decimal digits

    highload=$((`nproc`*90)) #Calculate high load threshold based on number of cores
    
    if test $load -ge $highload
    then
	#Change to default player if pulse audio is not installed
	paplay /usr/share/sounds/ubuntu/stereo/system-ready.ogg
	
	#PC Speaker is disabled on default configuration of Ubuntu
	#printf "\a" 
	
    fi
    
    sleep 5
done
