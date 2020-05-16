# Burn new image
# Use this to test the loop device

clean () {
  echo "WARNING: Starting to format the $1 device"
  dd if=/dev/zero of="$1" status=progress ; ec="$?"
  [ "$ec" = 0 ] && echo "Success: Disk has been clean" || echo "Error: Disk failed to clean"
}

sdburner () {
  checkroot
  # download_and_burn_image '/dev/sdc' '124'
  echo "Downloading from http://download.treehouses.io/treehouse-$2.img.gz"
  echo "Image name: treehouses-$2"
  echo "Disk name: $1"
  echo "Flashing the $1 now ... "
  # need a way to validate the file
  curl "http://download.treehouses.io/treehouse-$2.img.gz" | gunzip -c | sudo dd of="$1" status=progress ; ec="$?"
  # curl "http://download.treehouses.io/treehouses-$2.img.gz" | gunzip -c | sudo dd of="$1" status=progress ; ec="$?"
  [ "$ec" = 0 ] && echo "Done Flashing new image" || echo "Flashing failed" 

  umount "$1" ; ec="$?" ; sync 
  [ "$ec" = 0 ] && echo "Successfully umounted" || echo "Error: fail to unmount the device"
}

sdburner_help () {
  echo "Burn new tree image on raspberry pi"
  echo 'Examples:'
  echo '  treehouses sdburner clean /dev/sda         clean the disk drive' 
  echo "  treehouses sdburner /dev/sda 125  download and burn treehouses 125 image"
  echo ""
}

