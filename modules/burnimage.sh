function burnimage {
  option="$1"
  if [ "$option" == "list" ]; then
    lsblk
  elif [[ ( "$option" == "/dev/sda" || "$option" == "/dev/sdb" ) ]]; then
    if lsblk "$option" > /dev/null 2>&1; then
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

      if [ -f "latest.img.gz" ]; then
        echo "writing..."
        zcat "latest.img.gz" | sudo dd of=$option bs=1M conv=fsync
        echo "the image has been written, the treehouses image is still on $(pwd), you can remove or keep it for future burns"
      fi
    fi
  else
    echo "Error: no command found"
  fi
}

function burnimage_help {
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