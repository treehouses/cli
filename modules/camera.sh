#!/bin/bash

# potential improvements:
#    treehouses camera saveat "directory"
#    treehouses camera fliph
#    treehouses camera flipv
#  add reboot needed and if statement checks for it

function camera {
  directory="/home/pi/Pictures/"
  case "$1" in
    "on")
      if grep "# Enable Camera" /boot/config.txt ; then
        if grep "start_x=0" /boot/config.txt ; then
          sed -i "s/start_x=0/start_x=1/g" /boot/config.txt
          echo "Camera settings have been enabled. A reboot is needed in order to use the camera."
        else
          echo "Camera is already enabled. Use \"$(basename "$0") camera capture\" to take a photo."
          echo "If you are having issues using the camera, try rebooting."
        fi
      else
        echo -en "# Enable Camera\nstart_x=1\n" >> /boot/config.txt
        echo "Camera has been enabled. Restart to initialize it."
      fi
      ;;

    "off")
      if grep "start_x=1" /boot/config.txt ; then
        sed -i "s/start_x=1/start_x=0/g" /boot/config.txt
        echo "Camera has been disabled. Reboot needed for settings to take effect."
      else
        echo "Camera is already disabled. If camera is still enabled, try rebooting."
      fi
      ;;

    "capture")
      if [ -d "${directory}" ]; then
        if grep "start_x=0" /boot/config.txt ; then
          echo "You need to enable AND reboot first in order to take pictures."
        else
          echo "Camera is capturing and storing a time-stamped photo in ${directory}."
          raspistill -n -o "${directory}$(basename "$0")_$(date +"%Y-%m-%d_%H:%M:%S").jpg"
        fi
      else
        mkdir ${directory}
        echo "Directory not found. Creating ${directory}"
        camera "$1"
      fi
      ;;

    "")
      camera_help
      exit 0
      ;;

    "*")
      camera_help
      exit 0
      ;;
  esac
}

function camera_help {
echo ""
echo "  Usage: $(basename "$0") camera <on|off>        enables or disables camera for [capture] use"
echo "         $(basename "$0") camera [capture]       captures and stores a picture from camera onto pi's Desktop"
echo ""
echo "  Example:"
echo "    $(basename "$0") camera on"
echo "      Camera settings have been enabled. A reboot is needed in order to use the camera."
echo ""
echo "    $(basename "$0") camera on"
echo "      Camera is already enabled. Use \"$(basename "$0") camera capture\" to take a photo."
echo ""
echo "    $(basename "$0") camera capture"
echo "      Camera is capturing and storing a time-stamped photo in ${directory}."
echo ""
}
