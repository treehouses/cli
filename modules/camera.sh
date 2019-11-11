#!/bin/bash

function camera {
  directory="/home/pi/Pictures/"
  timestamp=$(date +"%Y%m%d-%H%M%S")
  case "$1" in
    "")
      if grep "# Enable Camera" /boot/config.txt ; then
        if grep "start_x=0" /boot/config.txt ; then
          echo "Config file has Camera settings which are currently disabled. Use \"$(basename "$0") help camera\" for more commands."
        elif grep "start_x=1" /boot/config.txt ; then
          echo "Config file has Camera settings which are currently enabled. Use \"$(basename "$0") help camera\" for more commands."
        else
          echo "Error encountered. Run \"$(basename "$0") help camera\" for more commands."
          exit 1
        fi
      else
        {
          echo "# Enable Camera"
          echo "start_x=0"
        } >> /boot/config.txt
        echo "Config file was not initialized for a Camera." 
        echo "Run \"$(basename "$0") camera on\" and reboot to enable the camera for use."
      fi
    ;;

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
        echo "Config settings have not been initialized for a Camera."
        echo "Run \"$(basename "$0") camera\" to initialize for camera use."		
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
      mkdir -p ${directory}
      if grep "start_x=0" /boot/config.txt ; then
        echo "You need to enable AND reboot first in order to take pictures."
        exit 1
      else
        echo "Camera is capturing and storing a time-stamped photo in ${directory}."
        raspistill -e png -n -o "${directory}$(basename "$0")-${timestamp}.png"
      fi
    ;;

    "*")
      camera_help
      exit 0
    ;;
  esac
}

function camera_help {
  echo ""
  echo "  Usage: $(basename "$0") camera [on|off|capture]      displays status of camera, enables or disables camera,"
  echo "                                                       captures and stores a picture from camera into pi's `Pictures` directory"
  echo ""
  echo "  Example:"
  echo "    $(basename "$0") camera"
  echo "      Config file has Camera settings which are currently disabled. Use \"$(basename "$0") help camera\" for more commands."
  echo ""
  echo "    $(basename "$0") camera on"
  echo "      Camera is already enabled. Use \"$(basename "$0") camera capture\" to take a photo."
  echo "      If you are having issues using the camera, try rebooting."
  echo ""
  echo "    $(basename "$0") camera off"
  echo "      Camera has been disabled. Reboot needed for settings to take effect."
  echo ""
  echo "    $(basename "$0") camera capture"
  echo "      Camera is capturing and storing a time-stamped photo in ${directory}."
  echo ""
}
