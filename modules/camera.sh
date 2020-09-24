function camera {
  local directory timestamp config configtemp savetype
  checkrpi
  checkargn $# 2
  directory="/home/pi/Pictures/"
  viddir="/home/pi/Videos/"
  timestamp=$(date +"%Y%m%d-%H%M%S")
  config="/boot/config.txt"
  configtemp="/boot/config.temp"
  savetype="png"
  vidtype="mp4"
  length=10

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
        echo "Camera settings have been enabled. A reboot is needed in order to use the camera."
        reboot_needed
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
        echo "Camera has been disabled. A reboot is needed in order to use the camera."
        reboot_needed
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

    "record")
      mkdir -p ${viddir}
      if ! grep -q "start_x=1" ${config} ; then
        echo "You need to enable AND reboot first in order to take pictures."
        exit 1
      fi
      case "$2" in 
        "")
          echo "Camera is recording ${length} seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
          let length=$length*1000
          raspivid -o "${viddir}$BASENAME-${timestamp}.h264" -t "${length}" && echo "Success: Video captured" && echo "Converting video to ${vidtype}"
          convert ${viddir}$BASENAME-${timestamp}.h264 ${viddir}$BASENAME-${timestamp}.${vidtype}
          rm ${viddir}$BASENAME-${timestamp}.h264
          ;;       
        
        *)
          if ! [[ "$2" =~ ^[1-9][0-9]*$ ]] ; then #^[0-9]+$ to accept 0 for indefinite recording
            echo "Positive integers only."
            exit 1
          else        
            echo "Camera is recording ${2} seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
            let length=$2*1000
            raspivid -o "${viddir}$BASENAME-${timestamp}.h264" -t "${length}" && echo "Success: Video captured" && echo "Converting video to ${vidtype}"
            convert ${viddir}$BASENAME-${timestamp}.h264 ${viddir}$BASENAME-${timestamp}.${vidtype}
            rm ${viddir}$BASENAME-${timestamp}.h264
          fi
          ;;
      esac
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
        elif file ${directory}$BASENAME-${timestamp}.png | grep -q "2582 x 1933" ; then
          echo "Coral Camera Module detected." 
          rm ${directory}$BASENAME-${timestamp}.png
        elif file ${directory}$BASENAME-${timestamp}.png | grep -q "3280 x 2464" ; then
          echo "Camera Module v2 detected."
          rm ${directory}$BASENAME-${timestamp}.png
        elif file ${directory}$BASENAME-${timestamp}.png | grep -q "4056 x 3040" ; then
          echo "HQ Camera detected."
          rm ${directory}$BASENAME-${timestamp}.png
        else
          echo "Unknown Camera detected. Something went wrong!"
          file ${directory}$BASENAME-${timestamp}.png 
          rm ${directory}$BASENAME-${timestamp}.png
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
  echo "Usage: $BASENAME camera [on|off|detect|capture|record]"
  echo
  echo "Example:"
  echo "  $BASENAME camera"
  echo "  Config file has Camera settings which are currently disabled. Use \"$BASENAME help camera\" for more commands."
  echo
  echo "  $BASENAME camera on"
  echo "  Camera is already enabled. Use \"$BASENAME camera capture\" to take a photo."
  echo "  If you are having issues using the camera, try rebooting."
  echo
  echo "  $BASENAME camera off"
  echo "  Camera has been disabled. Reboot needed for settings to take effect."
  echo
  echo "  $BASENAME camera detect"
  echo "  Camera is plugged in."
  echo "  Camera Module v1 detected."
  echo
  echo "  $BASENAME camera capture"
  echo "  Camera is capturing and storing a time-stamped photo in ${directory}."
  echo
  echo "  $BASENAME camera record"
  echo "  Camera is recording ${length} seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
  echo
  echo "  $BASENAME camera record [seconds]"
  echo "  Camera is recording [seconds] seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
  echo
}
