#!/bin/bash

function restore {
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

  echo "restoring...."
  echo u > /proc/sysrq-trigger
  dd if=/dev/mmcblk0 bs=1M of="$device"

}

function restore_help {
  echo
  echo "Usage: $BASENAME restore [device path]"
  echo
  echo "restores a treehouses image to an SDCard"
  echo "and is the logical brother of 'treehouses clone'"
  echo
  echo "Example:"
  echo "  $BASENAME restore"
  echo "      Will restore the current system to /dev/sdb (by default)."
  echo
  echo "  $BASENAME restore /dev/sda"
  echo "      Will restore the current system to /dev/sda"
  echo
}
