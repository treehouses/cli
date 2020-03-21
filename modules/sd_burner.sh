
image_checker () {
		if [ ! "${1#*.}" == ".img.gz" ]; then
				echo "Error: can't find the image or the image type is invalid"
				exit 1 
		fi
}

image_save () {
  local image_name="$(date +%Y-%m-%d)_$1" 
  local block_device="$2"
  root_check
  if [ -n "$2" ];
  then
				dd if="$block_device" conv=sync | gzip -c > "$image_name.img.gz" ; ec="$?"
				[ "$ec" -eq 0 ]  && echo "Sucess: image is backed up" || echo "Error: fail to back up the image"  
    du -h "$image_name.img.gz"
  else
    echo "Error: fail to back up the image"
  fi
}

erase_sd(){
		echo "WARNING: Starting to format the $1 device"
		dd if=/dev/zero of="$1" status=progress bs=1M  ; ec="$?"
		[ "$ec" = 0 ] && echo "Success: Disk has been clean" || echo "Error: Disk failed to clean"
}

download_and_burn_image () {
		root_check
		# download_and_burn_image '/dev/sdc' '124'
		echo "Downloading from http://dev.ole.org/treehouse-$2.img.gz"
		echo "Image name: treehouses-$2"
		echo "Disk name: $1"
		echo "Flashing the $1 now ... "

		curl "http://dev.ole.org/treehouse-$2.img.gz" | gunzip -c | sudo dd of="$1" status=progress ; ec="$?"
		[ "$ec" = 0 ] && echo "Done Flashing new image" || echo "Flashing failed" 

		umount "$1" ; ec="$?" ; sync 
		[ "$ec" = 0 ] && echo "Successfully umounted" || echo "Error: fail to unmount the device"
}

images_management () {
		echo "Usuage: $(basename $0) [-l|--list] [-c|--clean <device_name>] [-b|--burn <device_name> <image_name>] "
		echo ''
		echo 'Where:'
		echo '  -h,--help    show the help page'
		echo '  -l,--list    show current saved images'
		echo '  -c,--clean   clean the disk drive' 
		echo "  -b,--burn    burn an image"
		echo "Example: "
		echo "  $(basename $0) -b /dev/sda treehouses.gz"
		echo ''
}

