#!/bin/bash

function verbose {
  case "$1" in
    "")
      if [[ "$LOGFILE" == /dev/null ]]
      then
        echo "Verbosity is currently disabled"
      else
        echo "Verbosity is currently enabled"
      fi
      exit 0;
      ;;
    "on")
      LOGFILE=""
      echo "Successfully enabled verbosity"
      ;;
    "off")
      LOGFILE=/dev/null
      echo "Successfully disabled verbosity"
      ;;
    *)
      echo "Error: only 'on' and 'off' options are supported";
      exit 1;
      ;;
  esac
  if grep -q 'LOGFILE=' "$CONFIGFILE"
  then
    sed -i "s@^LOGFILE=.*\$@LOGFILE=$LOGFILE@" "$CONFIGFILE"
  else
    echo -e "LOGFILE=$LOGFILE\n" >> "$CONFIGFILE"
  fi
}

function verbose_help {
  echo ""
  echo "Usage: $(basename "$0") verbose <on|off>"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") verbose"
  echo "      Verbosity is currently disabled"
  echo ""
  echo "  $(basename "$0") verbose on"
  echo "      Successfully enabled verbosity"
  echo ""
  echo "  $(basename "$0") verbose off"
  echo "      Successfully disabled verbosity"
  echo ""
}
