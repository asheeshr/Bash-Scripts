#!/bin/bash

#Generate notification when hard disk utilisation exceeds specified limit

HD_LMT=80%

list=`df | sort -n` 
list=($list) #Create list from string
len=${#list[*]} #Calculate length of list

for ((i=0; i<len; i++)) #Iterate over list
do
    if [[ ${list[i]} == /dev/sd* ]] #Partial string matching for /dev drives
    then
	if [ ${list[i+4]} \> $HD_LMT ] #Check utilisation. > needs to be escaped
	then
	    paplay /usr/share/sounds/ubuntu/stereo/system-ready.ogg &
	fi
    fi 
done

