#!/bin/bash

function clone {
	if [ "$#" -gt 2 ]; then
		echo "Too many arguments."
		exit 1
	fi

	if [ $2 ]; then
		if [ $2 = "--reboot" ]; then
			device=$1
			reboot=true
		elif [ $1 = "--reboot" ]; then
			device=$2
			reboot=true
		else 
			echo "Incorrect command"
			exit 1
		fi
	elif [ $1 ]; then
		if [ $1 = "--reboot" ]; then	
			echo "reboot set"
			reboot=true
		else
			device=$1
		fi
	fi

		if [ -z "$device" ]; then
			device="/dev/sdb"
		fi


		a=$(fdisk -l |grep /dev/mmcblk0: | grep -P '\d+ (?=bytes)' -o)
		#echo "$a - /dev/mmcblk0"

		b=$(fdisk -l |grep "$device": | grep -P '\d+ (?=bytes)' -o)
		#echo "$b - /dev/sdb"

		if [ -z "$a" ] || [ -z "$b" ]; then
			echo "Error: the device $device wasn't detected"
			return 1
		fi

		if [ $b -lt $a ]; then
			echo "Error: the device $device is not big enough"
			return 1
		fi

		if [ $a -eq $b ] || [ $a -lt $b ]; then
			echo "copying...."
			echo u > /proc/sysrq-trigger
			dd if=/dev/mmcblk0 bs=1M of="$device"
		fi



		if [ $reboot ]; then
			echo "Now rebooting..."
			sudo reboot		
		else
			echo "A reboot is needed to re-enable write permissions to OS."
		fi
}


function clone_help {
	echo ""
	echo "Usage: $(basename "$0") clone [device path]"
	echo ""
	echo "clones your treehouses image to an SDCard"
	echo ""
	echo "Example:"
	echo "  $(basename "$0") clone"
	echo "      Will clone the current system to /dev/sdb (by default)."
	echo ""
	echo "  $(basename "$0") clone /dev/sda"
	echo "      Will clone the current system to /dev/sda."
	echo ""
	echo "  $(basename "$@") clone --reboot"	
	echo "      Will clone the current system to /dev/sdb and then reboot."
	echo ""
	echo "  $(basename "$@") clone /dev/sda --reboot"
	echo "       Will clone the current system to /dev/sda and then reboot."
}
