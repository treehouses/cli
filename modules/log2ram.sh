function log2ram {
  checkrpi
  checkroot
  checkargn $# 1
  if [ "$1" = "" ]; then
    if [[ $(df -h) != *"log2ram"* ]]; then
      echo "log2ram is off"
    else
      echo "log2ram is on"
    fi
  elif [ "$1" = "on" ]; then
    checkinternet
    curl -s -Lo log2ram.tar.gz https://github.com/azlux/log2ram/archive/master.tar.gz &>"$LOGFILE"
    tar xf log2ram.tar.gz &>"$LOGFILE"
    rm log2ram.tar.gz
    cd log2ram-master || exit
    chmod +x install.sh && ./install.sh &>"$LOGFILE"
    cd ..
    rm -r log2ram-master
    echo "Successfully enabled log2ram, please reboot"
  elif [ "$1" = "off" ]; then
    if [ -f "/usr/local/bin/uninstall-log2ram.sh" ]; then
      chmod +x /usr/local/bin/uninstall-log2ram.sh && /usr/local/bin/uninstall-log2ram.sh &>"$LOGFILE"
    fi
    echo "Sucessfully disabled log2ram"
  else
    log_and_exit1 "Error: only '', 'on', and 'off' options supported"
  fi
}

function log2ram_help {
  echo
  echo "Usage: $BASENAME log2ram [on|off]"
  echo
  echo "force logs to be stored in ram and only writes to disk on shutdown"
  echo "https://github.com/azlux/log2ram"
  echo "Stores logs in 40M (Megabytes) in mount point in memory"
  echo
  echo "Example:"
  echo "  $BASENAME log2ram"
  echo "      log2ram is off"
  echo
  echo "  $BASENAME log2ram on"
  echo "      Successfully enabled log2ram, please reboot"
  echo
  echo "  $BASENAME log2ram off"
  echo "      Successfully disabled log2ram"
  echo
}
