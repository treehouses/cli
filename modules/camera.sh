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
        cat ${config} > ${configtemp}
        echo "start_x=1" >> ${configtemp}
        cat ${configtemp} > ${config}
        echo "Camera settings have been enabled. A reboot is needed in order to use the camera."
      elif grep -q "start_x=1" ${config} ; then
        echo "Camera is already enabled. Use \"$BASENAME camera capture\" to take a photo."
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
        raspistill -e ${savetype} -n -o "${directory}$BASENAME-${timestamp}.png" && echo "Success: Pictures generated"
      fi
    ;;

    "record")
      case "$2" in 
        "")
          mkdir -p ${viddir}
          if ! grep -q "start_x=1" ${config} ; then
            echo "You need to enable AND reboot first in order to take pictures."
            exit 1
          else
            echo "Camera is recording ${length} seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
            let length=$length*1000
            raspivid -o "${viddir}$BASENAME-${timestamp}.h264" -t "${length}" && echo "Success: Video captured" && echo "Converting video to ${vidtype}"
            $BASENAME convert ${viddir}$BASENAME-${timestamp}.h264 ${viddir}$BASENAME-${timestamp}.${vidtype}
            rm ${viddir}$BASENAME-${timestamp}.h264          
          fi
        ;;

        *)
          mkdir -p ${viddir}    
          if ! grep -q "start_x=1" ${config} ; then
            echo "You need to enable AND reboot first in order to take pictures."
            exit 1
          elif ! [[ "$2" =~ ^[1-9][0-9]*$ ]] ; then
            echo "Positive integers only."
            exit 1
          else        
            echo "Camera is recording ${2} seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
            let length=$2*1000
            raspivid -o "${viddir}$BASENAME-${timestamp}.h264" -t "${length}" && echo "Success: Video captured" && echo "Converting video to ${vidtype}"
            $BASENAME convert ${viddir}$BASENAME-${timestamp}.h264 ${viddir}$BASENAME-${timestamp}.${vidtype}
            rm ${viddir}$BASENAME-${timestamp}.h264
          fi
        ;;
      esac
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
  echo "    $BASENAME camera record"
  echo "      Camera is recording ${length} seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
  echo
  echo "    $BASENAME camera record [seconds]"
  echo "      Camera is recording [seconds] seconds of video and storing a time-stamped ${vidtype} video in ${viddir}."
  echo
}