function detectrpi {
  local rpimodel found
  checkargn $# 1
  declare -A rpimodels
  rpimodels["Beta"]="BETA"
  rpimodels["0002"]="RPIB"
  rpimodels["0003"]="RPIB"
  rpimodels["0004"]="RPIB"
  rpimodels["0005"]="RPIB"
  rpimodels["0006"]="RPIB"
  rpimodels["0007"]="RPIA"
  rpimodels["0008"]="RPIA"
  rpimodels["0009"]="RPIA"
  rpimodels["000d"]="RPIB"
  rpimodels["000e"]="RPIB"
  rpimodels["000f"]="RPIB"
  rpimodels["0010"]="RPIB+"
  rpimodels["0011"]="CM"
  rpimodels["0012"]="RPIA+"
  rpimodels["0013"]="RPIB+"
  rpimodels["0014"]="CM"
  rpimodels["0015"]="RPIA+"
  rpimodels["a01040"]="RPI2B"
  rpimodels["a01041"]="RPI2B"
  rpimodels["a02042"]="RPI2B"
  rpimodels["a21041"]="RPI2B"
  rpimodels["a22042"]="RPI2B"
  rpimodels["900021"]="RPIA+"
  rpimodels["900032"]="RPIB+"
  rpimodels["900061"]="CM"
  rpimodels["900092"]="RPIZ"
  rpimodels["900093"]="RPIZ"
  rpimodels["920092"]="RPIZ"
  rpimodels["920093"]="RPIZ"
  rpimodels["9000c1"]="RPIZW"
  rpimodels["a020a0"]="CM3"
  rpimodels["a220a0"]="CM3"
  rpimodels["a02100"]="CM3+"
  rpimodels["a02082"]="RPI3B"
  rpimodels["a22082"]="RPI3B"
  rpimodels["a22083"]="RPI3B"
  rpimodels["a32082"]="RPI3B"
  rpimodels["a52082"]="RPI3B"
  rpimodels["a020d3"]="RPI3B+"
  rpimodels["9020e0"]="RPI3A+"
  rpimodels["a03111"]="RPI4B" # 1gb
  rpimodels["b03111"]="RPI4B" # 2gb
  rpimodels["b03112"]="RPI4B" # 2gb
  rpimodels["c03111"]="RPI4B" # 4gb
  rpimodels["c03112"]="RPI4B" # 4gb
  rpimodels["d03114"]="RPI4B" # 8gb
  # more at: https://www.raspberrypi.org/documentation/hardware/raspberrypi/revision-codes/README.md

  rpimodel=$(grep Revision /proc/cpuinfo | sed 's/.* //g' | tr -d '\n')

  found=0
  for i in "${!rpimodels[@]}";
  do
    if [ "$i" == "$rpimodel" ];
    then
      found=1
      break
    fi
  done

  if [ "$found" == 1 ];
  then
    if [[ "$1" == "" ]];
    then
      echo ${rpimodels[$rpimodel]}
    elif [[ "$1" == "model" ]];
    then
      echo "$rpimodel"
    elif [[ "$1" == "full" ]] && [[ "$2" == "" ]];
    then
      rpimodel=$(tr -d '\0' </sys/firmware/devicetree/base/model)
      echo "$rpimodel"
    else
      log_and_exit1 "Error: only 'detectrpi', 'detectrpi model', and 'detectrpi full' commands supported"
    fi
  else
    if grep -q -s "Raspberry Pi" "/sys/firmware/devicetree/base/model"; then
      echo "RPI"
    else
      echo "nonrpi"
    fi
  fi
}

function detectbluetooth {
  if hciconfig hci0 2>&1 | grep -q 'No such device'; then
    echo "false"
  else
    echo "true"
  fi
}

function detectarm {
  if [ "$(detectrpi)" = "nonrpi" ]; then
    echo "rpi required"
    exit 1
  else
    < /proc/cpuinfo grep "model name" | grep -oP '(?<=\().*(?=\))' -m1
  fi
}

function detectarch {
  lscpu | grep -oP 'Architecture:\s*\K.+'
}

function detectwifi {
  if iwconfig wlan0 2>&1 | grep -q "No such device"; then
    echo "false"
  else
    echo "true"
  fi
}

function detector {
  if [ "$(detectrpi)" != "nonrpi" ]; then
    echo "rpi $(detectrpi)"
  elif [ -d "/vagrant" ]; then
    if [ -f "/boot/version.txt" ]; then
      echo "vagrant $(cat /boot/version.txt)"
    else
      echo "vagrant other"
    fi
  else
    echo "other $(uname -m)"
  fi
}

function detect {
  case "$1" in
    "")
      checkargn $# 0
      detector
      ;;
    "rpi")
      checkargn $# 2
      detectrpi "$2"
      ;;
    "arm")
      checkargn $# 1
      detectarm
      ;;
    "arch")
      checkargn $# 1
      detectarch
      ;;
    "bluetooth")
      checkargn $# 1
      detectbluetooth
      ;;
    "wifi")
      checkargn $# 1
      detectwifi
      ;;
    *)
      echo "Error: only '', 'rpi', 'arm', 'arch', 'bluetooth', 'wifi' options supported."
      ;;
  esac
}

function detect_help {
  echo
  echo "Usage: $BASENAME detect"
  echo
  echo "Detects and outputs the hardware info"
  echo
  echo "Example:"
  echo "  $BASENAME detect"
  echo "      Prints the hardware info"
  echo
  echo "  $BASENAME detect rpi"
  echo "      Prints the Raspberry Pi name"
  echo
  echo "  $BASENAME detect rpi model"
  echo "      Prints the model number of the RPi"
  echo
  echo "  $BASENAME detect rpi full"
  echo "      Prints the full model of the RPi"
  echo
  echo "  $BASENAME detect arm"
  echo "      Prints arm version"
  echo
  echo "  $BASENAME detect arch"
  echo "      Prints the architecture"
  echo
  echo "  $BASENAME detect bluetooth"
  echo "      true"
  echo
  echo "  $BASENAME detect wifi"
  echo "    true"
  echo
}
