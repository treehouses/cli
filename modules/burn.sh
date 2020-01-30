#!/bin/bash

function burn {
    device="$1"
    if [ -z "$device" ]; then
        device="/dev/sdb"
    fi

    if [ ! -b "$device" ]; then
        echo "Error: the device $device wasn't detected"
        exit 1
    fi

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

    echo "writing..."
    zcat "latest.img.gz" > "$device"
    echo "the image has been written, the treehouses image is still on $(pwd), you can remove or keep it for future burns"
}


function burn_help {
  echo
  echo "Usage: $BASENAME burn [device path]"
  echo
  echo "downloads and burns the treehouse image to the specified device"
  echo
  echo "Example:"
  echo "  $BASENAME burn"
  echo "      Will download or update the treehouses image and write it to /dev/sdb (by default)."
  echo
  echo "  $BASENAME burn /dev/sda"
  echo "      Will download or update the treehouses image and write it to /dev/sda"
  echo
}
