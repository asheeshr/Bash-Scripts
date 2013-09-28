#!/bin/bash

#Generates notification when CPU load average is above specified limit

#Default Settings
AUDIO=YES #Sets audio notification
GRAPHICAL=YES #Sets notify-send/desktop notification
VERBOSE=NO #Sets terminal output
CPU_LOAD_TIME=1 #Set time duration for which to check load averages
CPU_LOAD_LMT=90 #Set limit for high load average. Any number >0
TIME_GAP_NOTIFICATIONS=0 #Set gap between successive notifications. Any number >=0
TIME_GAP_BOOT=30 #Set initial delay in starting. Any number >=0

#set -- `getopts agvc:l:t:i: "$@"` #Parse command line parameters and options
#while [ -n "$1" ] #Set settings to passed parameters

while getopts :agvc:l:t:i: opt
do
    case "$opt" in
	a) AUDIO=YES;;
	g) GRAPHICAL=YES;;
	v) VERBOSE=YES;;
	c) CPU_LOAD_TIME="$OPTARG";;
	    #shift ;;
	l) CPU_LOAD_LMT="$OPTARG";;
	    #shift ;;
	t) TIME_GAP_NOTIFICATIONs="$OPTARG";;
	    #shift ;;
	i) TIME_GAP_BOOT="$OPTARG";;
	    #shift ;;
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
fi


sleep $TIME_GAP_BOOT #To allow boot process to complete. CPU load will be high initially.

while true
do
    list=`cat /proc/loadavg`
    set -- $list
    load=$1 #Extract 1 minute cpu load
    load=`echo "scale=2; $load * 100" | bc` #Convert to integer
    load=`printf "%.0f" $load` #Remove decimal digits

    highload=$((`nproc`*$CPU_LOAD_LMT)) #Calculate high load threshold based on number of cores
    
    if test $load -ge $highload
    then
	#Change to default player if pulse audio is not installed
	if [ "YES" == $AUDIO ] 
	then
	    paplay /usr/share/sounds/ubuntu/stereo/system-ready.ogg
	fi

	#Generates visual notification
	if [ "YES" == $GRAPHICAL ]
	    then
	    notify-send -i /usr/share/icons/default.kde4/128x128/devices/cpu.png -t 400 "High CPU Load"'!' \
	fi
	"The CPU has been hard at work in the past minute."
	
	#PC Speaker is disabled on default configuration of Ubuntu
	#printf "\a" 
	
	if [ "YES" == $VERBOSE ]
	then
	    echo "CPU Load High!"
	fi

	sleep $TIME_GAP_NOTIFICATIONS #High load averages are reflected for the next few seconds 

    fi
    
    sleep 5
done
