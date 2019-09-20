#!/bin/bash

function clone {
    device="$1"
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

    if [ -f "/etc/reboot-needed" ]; then
        echo "Cloning completed.";
        echo "A reboot is needed. Would you like to reboot now?"
           select yn in "Yes" "No"; do
              case $yn in
                 Yes ) echo "Rebooting"; sleep 2 ; reboot; break;;
                 No ) exit;;
              esac
           done
    fi
}

function clone_help {
  echo ""
  echo "Usage: $(basename "$0") burn [device path]"
  echo ""
  echo "clones your treehouses image to an SDCard"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") clone"
  echo "      Will clone the current system to /dev/sdb (by default)."
  echo ""
  echo "  $(basename "$0") clone /dev/sda"
  echo "      Will clone the current system to /dev/sda"
}
