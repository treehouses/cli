#!/bin/bash

function camera {
  directory="/home/pi/Pictures/"
  timestamp=$(date +"%Y%m%d-%H%M%S")
  config="/boot/config.txt"
  configtemp="/boot/config.temp"
  savetype="png"

  case "$1" in
    "")
      if grep -q "start_x=1" ${config} ; then
          echo "Config file has Camera settings which are currently enabled. Use \"$(basename "$0") help camera\" for more commands."
      else
          echo "Config file has Camera settings which are currently disabled. Use \"$(basename "$0") help camera\" for more commands."
      fi
    ;;

    "on")
      if ! grep -q "start_x=1" ${config} ; then
        cat ${config} > ${configtemp}
        echo "start_x=1" >> ${configtemp}
        cat ${configtemp} > ${config}
        echo "Camera settings have been enabled. A reboot is needed in order to use the camera."
      elif grep -q "start_x=1" ${config} ; then
        echo "Camera is already enabled. Use \"$(basename "$0") camera capture\" to take a photo."
        echo "If you are having issues using the camera, try rebooting."
      else
        echo "Something went wrong."
      fi
    ;;

    "off")
      if grep -q "start_x=1" ${config} ; then
        sed -i '/start_x=1/d' ${config}
        echo "Camera has been disabled. Reboot needed for settings to take effect."
      elif ! grep -q "start_x=1" ${config} ; then
        echo "Camera is already disabled. If camera is still enabled, try rebooting."
      else
        echo "Something went wrong."
      fi
    ;;

    "capture")
      mkdir -p ${directory}
      if ! grep -q "start_x=1" ${config} ; then
        echo "You need to enable AND reboot first in order to take pictures."
        exit 1
      else
        echo "Camera is capturing and storing a time-stamped ${savetype} photo in ${directory}."
        raspistill -e ${savetype} -n -o "${directory}$(basename "$0")-${timestamp}.png" && echo "Success: Pictures generated"
      fi
    ;;

    "*")
      camera_help
      exit 0
    ;;
  esac
}

function camera_help {
  echo
  echo "  Usage: $(basename "$0") camera [on|off|capture]      enables camera, disables camera, captures png photo"
  echo
  echo "  Example:"
  echo "    $(basename "$0") camera"
  echo "      Config file has Camera settings which are currently disabled. Use \"$(basename "$0") help camera\" for more commands."
  echo
  echo "    $(basename "$0") camera on"
  echo "      Camera is already enabled. Use \"$(basename "$0") camera capture\" to take a photo."
  echo "      If you are having issues using the camera, try rebooting."
  echo
  echo "    $(basename "$0") camera off"
  echo "      Camera has been disabled. Reboot needed for settings to take effect."
  echo
  echo "    $(basename "$0") camera capture"
  echo "      Camera is capturing and storing a time-stamped photo in ${directory}."
  echo
}
