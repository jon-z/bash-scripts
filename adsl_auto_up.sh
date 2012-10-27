#! /bin/bash
#
# Script to start pppoe session if it is not active or if there is not L3 connectivity

# Check layer 2
if [ $( /sbin/ip link show eth0 | /bin/grep UP &> /dev/null ; /bin/echo $? ) != 0 ]
	then
		$( /sbin/ifconfig eth0 up )
fi

if [ $( /sbin/ip link show | /bin/grep ppp &> /dev/null ; /bin/echo $? ) != 0 ]
	then
		$( /usr/bin/poff -a &> /dev/null && /usr/bin/pon dsl-provider &> /dev/null || /usr/bin/pon dsl-provider &> /dev/null )
	exit 1
fi 

# Check layer 3
if [ $( /bin/ip addr show ppp0 | /bin/grep ppp0 &> /dev/null ; /bin/echo $? ) != 0 ]
	then
		$( /usr/bin/poff -a &> /dev/null && /usr/bin/pon dsl-provider &> /dev/null || /usr/bin/pon dsl-provider &> /dev/null )
	exit 1
fi

PEER=$( /bin/ip addr show ppp0 | /bin/grep inet | /usr/bin/cut -d " " -f8 | /usr/bin/cut -d / -f1 )
if [ $( /bin/ping -c 1 "$PEER" &> /dev/null ; /bin/echo $? ) != 0  ]
	then
		$( /usr/bin/poff -a &> /dev/null && /usr/bin/pon dsl-provider &> /dev/null || /usr/bin/pon dsl-provider &> /dev/null )
	exit 1
fi
exit 0
