#!/bin/bash

function restore {

  echo "restoring...."
  echo u > /proc/sysrq-trigger
  dd if=/dev/mmcblk0 bs=1M of=/dev/sdb

}

function restore_help {
  echo ""
  echo "Usage: $(basename "$0")"
  echo ""
  echo "restores a treehouses image to an SDCard"
  echo "this is the logical brother of 'treehouses clone'"
  echo ""
}
