#!/bin/bash

#Generates notification when CPU load average is above specified limit

#Default Settings
AUDIO=NO #Sets audio notification
GRAPHICAL=NO #Sets notify-send/desktop notification
VERBOSE=NO #Sets terminal output
CPU_LOAD_TIME=1 #Set time duration for which to check load averages. Later set to argument number. Initial 1, 5 or 15
CPU_LOAD_LMT=90 #Set limit for high load average. Any number >0
TIME_GAP_NOTIFICATIONS=5 #Set gap between successive notifications. Any number >=0
TIME_GAP_BOOT=30 #Set initial delay in starting. Any number >=0
TIME_PERIOD=5 #Sets timegap between successive runs

#set -- `getopts agvc:l:t:i: "$@"` #Parse command line parameters and options
#while [ -n "$1" ] #Set settings to passed parameters

while getopts :agvt:l:n:b:p: opt
do
    case "$opt" in
	a) AUDIO=YES;;
	g) GRAPHICAL=YES;;
	v) VERBOSE=YES;;
	t) case $OPTARG in
	    #1) CPU_LOAD_TIME=1;; #Set by default
	    5) CPU_LOAD_TIME=2;;
	    15)CPU_LOAD_TIME=3;;
	    esac;;
	    #shift ;;
        l) if [ $OPTARG -gt 0 ] 
	   then
	       CPU_LOAD_LMT="$OPTARG"
	   fi;;
	    #shift ;;
	n) if [ $OPTARG -ge 0 ] 
	   then 
	       TIME_GAP_NOTIFICATIONS="$OPTARG"
	   fi;;
	    #shift ;;
	b) if [ $OPTARG -ge 0 ] 
	   then 
	       TIME_GAP_BOOT="$OPTARG"
	   fi;;
	    #shift ;;
	p) if [ $OPTARG -ge 0 ]
	   then 
	       TIME_PERIOD="$OPTARG"
	   fi;;
	*) ;;
	esac
done

if [ "YES" == $VERBOSE ] #Displaying settings
then 
    echo "Parameters set:"
    echo "Audio : $AUDIO"
    echo "Graphical : $GRAPHICAL"
    echo "Verbose : $VERBOSE"
    echo "Load Average Used : $CPU_LOAD_TIME"
    echo "Limit for high load : $CPU_LOAD_LMT"
    echo "Initial time delay : $TIME_GAP_BOOT"
    echo "Gap between successive notifications : $TIME_GAP_NOTIFICATIONS"
    echo ""
fi


sleep $TIME_GAP_BOOT #To allow boot process to complete. CPU load will be high initially.

while true
do
    list=`cat /proc/loadavg`
    set -- $list
    
    load=$CPU_LOAD_TIME #Extract required cpu load
    load=`echo "scale=2; $load * 100" | bc` #Convert to integer
    load=`printf "%.0f" $load` #Remove decimal digits

    highload=$((`nproc`*$CPU_LOAD_LMT)) #Calculate high load threshold based on number of cores
    
    if test $load -ge $highload
    then
	
	if [ "YES" == $AUDIO ] 
	then
	    paplay /usr/share/sounds/ubuntu/stereo/system-ready.ogg &
	fi

	#Generates visual notification
	if [ "YES" == $GRAPHICAL ]
	then
	    notify-send -i /usr/share/icons/default.kde4/128x128/devices/cpu.png "High CPU Load"'!' \
		"The CPU has been hard at work in the past minute." #No support for timeouts. Default is 5 seconds.
	    #notify-send bug report https://bugs.launchpad.net/ubuntu/+source/notify-osd/+bug/390508
	fi		
	
	#PC Speaker is disabled on default configuration of Ubuntu
	#printf "\a" 
	
	if [ "YES" == $VERBOSE ]
	then
	    echo "CPU Load High!"
	fi

	sleep $TIME_GAP_NOTIFICATIONS #High load averages are reflected for the next few seconds 

    fi

    sleep $TIME_PERIOD
done
