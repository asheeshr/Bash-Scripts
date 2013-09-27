#!/bin/bash

#Generates notification when CPU load average is above specified limit

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

	#Generates visual notification
	notify-send -i /usr/share/icons/default.kde4/128x128/devices/cpu.png -t 400 "High CPU Load"'!' \
	"The CPU has been hard at work in the past minute"
	
	#PC Speaker is disabled on default configuration of Ubuntu
	#printf "\a" 
	
	sleep 5 #High load averages are reflected for the next few seconds 

    fi
    
    sleep 5
done
