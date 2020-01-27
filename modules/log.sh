#!/bin/bash

function log {
  case "$1" in
    "")
      if [[ "$LOG" == 0 ]]; then
        echo "Log is off"
      else
        echo "Log is on"
      fi
      exit 0
      ;;
    "0")
      LOG=0
      echo "Logging disabled"
      ;;
    "1")
      LOG=1
      echo "Logging enabled"
      ;;
    "2")
      LOG=2
      echo "Logging to screen"
      ;;
    *)
      echo "Error: only '0' and '1' are supported"
      exit 1
      ;;
  esac

  conf_var_update "LOG" "$LOG"
}

function adddate {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date -u '+%D %T')" "$line";
    done
}

function logger {
  if [ ! -a /var/log/treehouses.log ]; then
    sudo touch /var/log/treehouses.log
    sudo chmod ugo+rw /var/log/treehouses.log
  fi

  if [[ "$LOG" == 1 ]]; then
    echo "$*" | adddate >> /var/log/treehouses.log
  fi

  if [[ "$LOG" == 2 ]]; then
    LOGFILE=$(tty)
    echo "$*"
  fi

}


