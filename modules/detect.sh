function detectrpi {
  local rpimodel found
  checkargn $# 1
  declare -A rpimodels

  # Beta models
  rpimodels["Beta"]="BETA" # Beta version

  # Raspberry Pi A models
  rpimodels["0007"]="RPIA" # 256MB 
  rpimodels["0008"]="RPIA" # 256MB
  rpimodels["0009"]="RPIA" # 256MB
  rpimodels["0012"]="RPIA+" # 256MB
  rpimodels["0015"]="RPIA+" # 256MB/512MB
  rpimodels["900021"]="RPIA+" # 512MB
  rpimodels["9020e0"]="RPI3A+" # 512MB
  rpimodels["9020e1"]="RPI3A+" # 512MB

  # Raspberry Pi B models
  rpimodels["0002"]="RPIB" # 256MB
  rpimodels["0003"]="RPIB" # 256MB
  rpimodels["0004"]="RPIB" # 256MB
  rpimodels["0005"]="RPIB" # 256MB
  rpimodels["0006"]="RPIB" # 256MB
  rpimodels["000d"]="RPIB" # 512MB
  rpimodels["000e"]="RPIB" # 512MB
  rpimodels["000f"]="RPIB" # 512MB
  rpimodels["0010"]="RPIB+" # 512MB
  rpimodels["0013"]="RPIB+" # 512MB
  rpimodels["900032"]="RPIB+" # 512MB

  # Compute Module models
  rpimodels["0011"]="CM" # 512MB
  rpimodels["0014"]="CM" # 512MB
  rpimodels["900061"]="CM" # 512MB
  rpimodels["a020a0"]="CM3" # 1GB
  rpimodels["a220a0"]="CM3" # 1GB
  rpimodels["a02100"]="CM3+" # 1GB
  rpimodels["a03140"]="CM4" # 1GB
  rpimodels["b03140"]="CM4" # 2GB
  rpimodels["c03140"]="CM4" # 4GB
  rpimodels["d03140"]="CM4" # 8GB

  # Raspberry Pi 2B models
  rpimodels["a01040"]="RPI2B" # 1GB
  rpimodels["a01041"]="RPI2B" # 1GB
  rpimodels["a02042"]="RPI2B" # 1GB
  rpimodels["a21041"]="RPI2B" # 1GB
  rpimodels["a22042"]="RPI2B" # 1GB

  # Raspberry Pi 3 models
  rpimodels["a02082"]="RPI3B" # 1GB
  rpimodels["a22082"]="RPI3B" # 1GB
  rpimodels["a22083"]="RPI3B" # 1GB
  rpimodels["a32082"]="RPI3B" # 1GB
  rpimodels["a52082"]="RPI3B" # 1GB
  rpimodels["a020d3"]="RPI3B+" # 1GB
  rpimodels["a020d4"]="RPI3B+" # 1GB

  # Raspberry Pi 4B models
  rpimodels["a03111"]="RPI4B" # 1GB
  rpimodels["b03111"]="RPI4B" # 2GB
  rpimodels["b03112"]="RPI4B" # 2GB
  rpimodels["b03114"]="RPI4B" # 2GB
  rpimodels["b03115"]="RPI4B" # 2GB
  rpimodels["c03111"]="RPI4B" # 4GB
  rpimodels["c03112"]="RPI4B" # 4GB
  rpimodels["c03114"]="RPI4B" # 4GB
  rpimodels["c03115"]="RPI4B" # 4GB
  rpimodels["d03114"]="RPI4B" # 8GB
  rpimodels["d03115"]="RPI4B" # 8GB

  # Raspberry Pi 5 models
  rpimodels["c04170"]="RPI5" # 4GB
  rpimodels["d04170"]="RPI5" # 8GB

  # Raspberry Pi 400
  rpimodels["c03130"]="RPI400" # 4GB

  # Raspberry Pi Zero models
  rpimodels["900092"]="RPIZ" # 512MB
  rpimodels["900093"]="RPIZ" # 512MB
  rpimodels["920092"]="RPIZ" # 512MB
  rpimodels["920093"]="RPIZ" # 512MB
  rpimodels["9000c1"]="RPIZW" # 512MB
  rpimodels["902120"]="RPIZ2W" # 512MB

  # more at: https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#new-style-revision-codes-in-use

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
    log_and_exit1 "Error: rpi required"
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
