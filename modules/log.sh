#!/bin/bash

lines=$3

function log {
  case "$1" in
    "")
      echo "Logging level: $LOG"
      exit 0
      ;;
    "0")
      LOG=0
      echo "Logging level set to 0"
      ;;
    "1")
      LOG=1
      echo "Logging level set to 1"
      ;;
    "2")
      LOG=2
      echo "Logging level set to 2"
      ;;
    "display")
      display
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

function display {
  if [ ! $lines ]; then
    cat /var/log/treehouses.log
  else
    sudo tail -n "$lines" /var/log/treehouses.log
  fi
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


