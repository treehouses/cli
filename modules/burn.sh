#!/bin/bash

function burn {
  option="$1"
  device="/dev/sda"
  if [ "$option" == "list" ]; then
    lsblk
  # else
    # if [ -z "$option" ]; then
    #     device="/dev/sda"
    #     # device="/dev/mmcblk0"
    # fi

    # if [ ! -b "$option" ]; then
    #     echo "Error: the device $option wasn't detected"
    #     exit 1
    # fi
  elif [ "$option" == "detect" ]; then
    if lsblk /dev/sd* > /dev/null 2>&1; then 
      echo "The device \"$device\" exists"
    else
      echo "Error: the device \"$device\" was not detected"
      exit 1
    fi
  else

    # if [ -b "/dev/sda/" ]; then
    #   echo "$device exists."
    #   exit 1
    # else
    #   echo "does not exist."
    #   exit 1
    # fi


    echo "downloading treehouses image."
    rm -f new.sha1
    if wget "http://dev.ole.org/latest.img.gz.sha1" -O new.sha1; then
      if [[ ! -e "latest.img.gz" ]] || [[ ! -e "latest.img.gz.sha1" ]] || [[ $(cat new.sha1) != $(cat latest.img.gz.sha1) ]]; then
        rm -f "latest.img.gz.sha1"
        wget "http://dev.ole.org/latest.img.gz.sha1"
        rm -f "latest.img.gz"
        wget "http://dev.ole.org/latest.img.gz"
      else
        echo "the image is up-to-date"
      fi
    fi

    zcat "latest.img.gz"
    if [ -f "latest.img.gz" ]; then
      echo "writing..."
      # zcat "latest.img.gz" > "$option"
      # zcat "latest.img.gz" > $device
      sudo dd if="latest.img.gz" of=$device bs=1M conv=fsync
      echo "the image has been written, the treehouses image is still on $(pwd), you can remove or keep it for future burns"
    fi
  fi
}


function burn_help {
  echo ""
  echo "Usage: $(basename "$0") burn [device path]"
  echo ""
  echo "downloads and burns the treehouse image to the specified device"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") burn"
  echo "      Will download or update the treehouses image and write it to /dev/sdb (by default)."
  echo ""
  echo "  $(basename "$0") burn /dev/sda"
  echo "      Will download or update the treehouses image and write it to /dev/sda"
}