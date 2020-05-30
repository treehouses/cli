function camera {
  local directory timestamp config configtemp savetype
  checkrpi
  checkargn $# 1
  directory="/home/pi/Pictures/"
  timestamp=$(date +"%Y%m%d-%H%M%S")
  config="/boot/config.txt"
  configtemp="/boot/config.temp"
  savetype="png"

  case "$1" in
    "")
      if grep -q "start_x=1" ${config} ; then
          echo "Config file has Camera settings which are currently enabled. Use \"$BASENAME help camera\" for more commands."
      else
          echo "Config file has Camera settings which are currently disabled. Use \"$BASENAME help camera\" for more commands."
      fi
    ;;

    "on")
      if ! grep -q "start_x=1" ${config} ; then
        raspi-config nonint do_camera 0
        echo "Camera settings have been enabled."
      elif grep -q "start_x=1" ${config} ; then
        echo "Camera is already enabled. Use \"$BASENAME camera capture\" to take a photo."
        echo "If you are having issues using the camera, try rebooting."
      else
        echo "Something went wrong."
      fi
    ;;

    "off")
      if grep -q "start_x=1" ${config} ; then
        raspi-config nonint do_camera 1
        echo "Camera has been disabled."
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
        raspistill -e ${savetype} -n -o "${directory}$BASENAME-${timestamp}.png" && echo "Success: Pictures generated"
      fi
    ;;

    "detect")
    mkdir -p ${directory}
    if ! grep -q "start_x=1" ${config} ; then
      echo "You need to enable AND reboot first in order to take pictures."
      exit 1
    else
      if camera capture |& grep -q "mmal: main:" ; then
        echo "Camera is not plugged in."
      else
        echo "Camera is plugged in."
        if file ${directory}$BASENAME-${timestamp}.png | grep -q "2592 x 1944" ; then
          echo "Camera Module v1 detected."
          rm ${directory}$BASENAME-${timestamp}.png
        elif file ${directory}$BASENAME-${timestamp}.png | grep -q "3280 × 2464" ; then
          echo "Camera Module v2 detected."
          rm ${directory}$BASENAME-${timestamp}.png
        elif file ${directory}$BASENAME-${timestamp}.png | grep -q "4056 x 3040" ; then
          echo "HQ Camera detected."
          rm ${directory}$BASENAME-${timestamp}.png
        else
          echo "Unknown Camera detected. Something went wrong!"
        fi
      fi
    fi
    ;;

    "*")
      camera_help
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
  echo "    $BASENAME camera detect"
  echo "      Camera is plugged in."
  echo "      Camera Module v1 detected."
  echo
}
