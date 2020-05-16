#!/bin/bash
# Burn new image
# Use this to test the loop device

create_loop_device () {
  local file_size='4G'
  local file_name='./dummy.img'
  local next_loop_device="$(sudo losetup -f)"

  root_check
  fallocate -l "$file_size" "$file_name" && echo "Finished creating dummy file" 
  # check loop device here 
  losetup "$next_loop_device" "$file_name"  && echo 'Loop device successfully mounted' 
}

erase_sd(){
  echo "WARNING: Starting to format the $1 device"
  dd if=/dev/zero of="$1" status=progress ; ec="$?"
  [ "$ec" = 0 ] && echo "Success: Disk has been clean" || echo "Error: Disk failed to clean"
}

download_and_burn_image () {
  root_check
  # download_and_burn_image '/dev/sdc' '124'
  echo "Downloading from http://dev.ole.org/treehouse-$2.img.gz"
  echo "Image name: treehouses-$2"
  echo "Disk name: $1"
  echo "Flashing the $1 now ... "
  # need a way to validate the file
  curl "http://dev.ole.org/treehouse-$2.img.gz" | gunzip -c | sudo dd of="$1" status=progress ; ec="$?"
  [ "$ec" = 0 ] && echo "Done Flashing new image" || echo "Flashing failed" 

  umount "$1" ; ec="$?" ; sync 
  [ "$ec" = 0 ] && echo "Successfully umounted" || echo "Error: fail to unmount the device"
}

sdburner_help () {
  echo "Usage: $(basename $0) [help] [clean /dev/sda] [burn <device_name> <image_name>] "
  echo ""
  echo "Burn new tree image on raspberry pi"
  echo 'Examples:'
  echo '  treehouses help               show the help page'
  echo '  treehouses clean /dev/sda     clean the disk drive' 
  echo "  treehouses burn /dev/sda 125  download and burn treehouses 125 image"
  echo ""
}

