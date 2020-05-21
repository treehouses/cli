function tpuinstall {
  if [ ! -z "$1" ] && [ "$1" != "cplusplus" ]; then
    echo "Error: only 'cplusplus' option supported"
    exit 1
  fi
  if [ "$(dpkg-query -W -f='${Status}' libedgetpu1-std 2>"$LOGFILE" | grep -c 'ok installed')" -eq 0 ]; then
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &>"$LOGFILE"
    apt-get -y -qq update
    apt-get -y -qq install libedgetpu1-std
    if [ -z "$1" ]; then
      # Raspbian Buster Python 3.7 Tensor Flow Lite
      yes | pip3 -qq install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_armv7l.whl
    fi
    echo "Successfully Installed"
  else
    echo "Error: already installed please run '$BASENAME coraltpu remove' first"
    exit 1
  fi
}

function tpuremove {
  if [ "$(dpkg-query -W -f='${Status}' libedgetpu1-std 2>"$LOGFILE" | grep -c 'ok installed')" -ne 0 ]; then
    yes | pip3 -qq uninstall https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_armv7l.whl
    rm -f /etc/apt/sources.list.d/coral-edgetpu.list
    apt-get -y -qq remove libedgetpu1-std
  fi
  echo "Successfully Removed"
}

function coraltpu {
  checkrpi
  checkroot
  case "$1" in
    install)
      checkargn $# 2
      tpuinstall "$2"
    ;;
    remove)
      checkargn $# 1
      tpuremove
    ;;
    *)
      echo "Error: only 'install', 'remove' options supported"
      exit 1
    ;;
  esac
}

function coraltpu_help {
  echo
  echo "Usage: $BASENAME coraltpu <install|remove> [cplusplus]"
  echo
  echo "Controls the coral usb accelerator"
  echo
  echo "Example:"
  echo "  $BASENAME coraltpu install"
  echo "      Installs the packages assuming python environment"
  echo
  echo "  $BASENAME coraltpu install cplusplus"
  echo "      Installs the packages assuming C++ environment"
  echo
  echo "  $BASENAME coraltpu remove"
  echo "      Removes everything"
  echo
}
