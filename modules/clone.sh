function clone {
  local argument a b
  checkrpi
  checkroot
  checkargn $# 1
  argument="$1"
  path=$(fdisk -l | grep -o '^/dev/sd[a-z]' | sort -u)

  case $argument in

    "detect")
      if [[ $path != *"dev"* ]]; then
        echo "Error: Could not detect any devices. Try plugging your device into a different slot."

      else
        echo $path
      fi
      ;;

    *)
      if [ -z "$argument" ]; then
      argument="/dev/sdb"
      fi

      a=$(fdisk -l |grep /dev/mmcblk0: | grep -P '\d+ (?=bytes)' -o)
      #echo "$a - /dev/mmcblk0"

      b=$(fdisk -l |grep "$argument": | grep -P '\d+ (?=bytes)' -o)
      #echo "$b - /dev/sdb"

      if [ -z "$a" ] || [ -z "$b" ]; then
        echo "Error: the device $argument wasn't detected. Please use '$BASENAME clone detect' to find the device name."
        return 1
      fi

      if [ $b -lt $a ]; then
        echo "Error: the device $argument is not big enough"
        return 1
      fi

      if [ $a -eq $b ] || [ $a -lt $b ]; then
        echo "copying...."
        echo u > /proc/sysrq-trigger
        dd if=/dev/mmcblk0 bs=1M of="$argument" status=progress
      fi

      echo ; echo "A reboot is needed to re-enable write permissions to OS."
      ;;
    esac
}

function clone_help {
  echo
  echo "Usage: $BASENAME clone [device path]"
  echo
  echo "clones your treehouses image to an SDCard"
  echo
  echo "Example:"
  echo "  $BASENAME clone"
  echo "      Will clone the current system to /dev/sdb (by default)."
  echo
  echo "  $BASENAME clone /dev/sda"
  echo "      Will clone the current system to /dev/sda"
  echo
}
