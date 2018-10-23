#!/bin/bash

function restore {

  a=$(fdisk -l |grep /dev/mmcblk0: | grep -P '\d+ (?=bytes)' -o)
  #echo "$a - /dev/mmcblk0"
  
  b=$(fdisk -l |grep /dev/sdb: | grep -P '\d+ (?=bytes)' -o)
  #echo "$b - /dev/sdb"
  
  if [ -z "$a" ] || [ -z "$b" ]; then
      echo "no SDCard detected"
      return 1
  fi

  echo "restoring...."
  echo u > /proc/sysrq-trigger
  dd if=/dev/mmcblk0 bs=1M of=/dev/sdb

}

function restore_help {
  echo ""
  echo "Usage: $(basename "$0")"
  echo ""
  echo "restores a treehouses image to an SDCard"
  echo "and is the logical brother of 'treehouses clone'"
  echo ""
}
