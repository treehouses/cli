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
          logit "Config file has Camera settings which are currently enabled. Use \"$BASENAME help camera\" for more commands."
      else
          logit "Config file has Camera settings which are currently disabled. Use \"$BASENAME help camera\" for more commands."
      fi
    ;;

    "on")
      if ! grep -q "start_x=1" ${config} ; then
        cat ${config} > ${configtemp}
        echo "start_x=1" >> ${configtemp}
        cat ${configtemp} > ${config}
        logit "Camera settings have been enabled. A reboot is needed in order to use the camera." "" "WARNING"
      elif grep -q "start_x=1" ${config} ; then
        logit "Camera is already enabled. Use \"$BASENAME camera capture\" to take a photo."
        logit "If you are having issues using the camera, try rebooting."
      else
        logit "Something went wrong." "" "ERROR"
      fi
    ;;

    "off")
      if grep -q "start_x=1" ${config} ; then
        sed -i '/start_x=1/d' ${config}
        logit "Camera has been disabled. Reboot needed for settings to take effect." "" "WARNING"
      elif ! grep -q "start_x=1" ${config} ; then
        logit "Camera is already disabled. If camera is still enabled, try rebooting."
      else
        logit "Something went wrong." "" "ERROR"
      fi
    ;;

    "capture")
      mkdir -p ${directory}
      if ! grep -q "start_x=1" ${config} ; then
        log_and_exit1 "You need to enable AND reboot first in order to take pictures."
      else
        logit "Camera is capturing and storing a time-stamped ${savetype} photo in ${directory}."
        raspistill -e ${savetype} -n -o "${directory}$BASENAME-${timestamp}.png" && echo "Success: Pictures generated"
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
  echo "  Usage: $BASENAME camera [on|off|capture]      enables camera, disables camera, captures png photo"
  echo
  echo "  Example:"
  echo "    $BASENAME camera"
  echo "      Config file has Camera settings which are currently disabled. Use \"$BASENAME help camera\" for more commands."
  echo
  echo "    $BASENAME camera on"
  echo "      Camera is already enabled. Use \"$BASENAME camera capture\" to take a photo."
  echo "      If you are having issues using the camera, try rebooting."
  echo
  echo "    $BASENAME camera off"
  echo "      Camera has been disabled. Reboot needed for settings to take effect."
  echo
  echo "    $BASENAME camera capture"
  echo "      Camera is capturing and storing a time-stamped photo in ${directory}."
  echo
}
