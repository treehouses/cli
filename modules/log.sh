#!/bin/bash

function logit() {
  if [[ "$LOG" == "ON" ]]; then
    case "$3" in
      "")
        logger -p local0.info "$1"
        ;;
      "WARNING")
        logger -p local0.warning "$1"
        ;;
      "ERROR")
        logger -p local0.err "$1"
        ;;
      "DEBUG")
        logger -p local0.debug "$1"
        ;;
    esac
  fi
  if [[ "$2" == "1" ]]; then
    return 0;
  fi
  echo "$1"
}

function log {
  case "$1" in
    "")
      if [[ "$LOG" == "OFF" ]]
      then
        echo "Log is off"
      else
        echo "Log is on"
      fi
      exit 0;
      ;;
    "1")
      LOG=ON
      echo "Successfully enabled Log"
      ;;
    "0")
      LOG=OFF
      echo "Successfully disabled Log"
      ;;
    *)
      echo "Error: only '1' and '0' options are supported";
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
  echo
  echo "Usage: $(basename "$0") log <0|1>"
  echo
  echo "Example:"
  echo "  $(basename "$0") log"
  echo "      Log is off"
  echo
  echo "  $(basename "$0") log 0"
  echo "      Successfully disabled Log"
  echo
  echo "  $(basename "$0") log 1"
  echo "      Successfully enabled Log"
  echo
}
