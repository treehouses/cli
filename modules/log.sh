#!/bin/bash

function logger() {
  
  log_string="$1"
  log_level="$2"
  log_loc="${LOGFOLDER}${date +"%Y-%m-%d"}.log"
  
  if [ ! -f "$log_loc" ]; then
    touch "$log_loc"
  fi
  echo -e "${log_level}:${log_string}" > > "$log_loc"
}

function log_info() {
  logger "$1" "INFO"
}

function log_warning() {
  logger "$1" "WARNING"
}

function log_error() {
  logger "$1" "ERROR"
}

function log_debug() {
  logger "$1" "DEBUG"
}

function log_success() {
  logger "$1" "SUCCESS"
}


function log {
  case "$1" in
    "")
      if [[ "$LOG" == OFF ]]
      then
        echo "Log is off"
      else
        echo "Log is on"
      fi
      exit 0;
      ;;
    "on")
      LOG=ON
      echo "Successfully enabled Log"
      ;;
    "off")
      LOG=OFF
      echo "Successfully disabled Log"
      ;;
    *)
      echo "Error: only 'on' and 'off' options are supported";
      exit 1;
      ;;
  esac
  s1="LOG="
  if [[ $CONFIGFILE = *"$s1"* ]]
  then
    sed -i "s@^$s1.*\$@$s1$LOG@" "$CONFIGFILE"
  else
    echo -e "$s1$LOG\n" >> "$CONFIGFILE"
  fi
}

function log_help {
  echo ""
  echo "Usage: $(basename "$0") log <on|off>"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") log"
  echo "      Log is off"
  echo ""
  echo "  $(basename "$0") log on"
  echo "      Successfully enabled Log"
  echo ""
  echo "  $(basename "$0") log off"
  echo "      Successfully disabled Log"
  echo ""
}
