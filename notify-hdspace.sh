#!/bin/bash

#Generate notification when hard disk utilisation exceeds specified limit

HD_LMT=70%

NOTIFICATION_SOUND="/usr/share/sounds/ubuntu/stereo/system-ready.ogg"
NOTIFICATION_ICON="/usr/share/icons/default.kde4/128x128/devices/drive-harddisk.png"

list=`df | sort -n` 
list=($list) #Create list from string
len=${#list[*]} #Calculate length of list

for ((i=0; i<len; i++)) #Iterate over list
do
    if [[ ${list[i]} == /dev/sd* ]] #Partial string matching for /dev drives
    then
	if [ ${list[i+4]} \> $HD_LMT ] #Check utilisation. > needs to be escaped
	then
	    disk=$(basename ${list[i]})
	    paplay $NOTIFICATION_SOUND &
	    notify-send -i $NOTIFICATION_ICON "Storage Memory Full!" "Disk $disk is over ${list[i+4]} full"
	fi
    fi 
done
