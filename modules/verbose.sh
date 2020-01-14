#!/bin/bash

function verbose {
  case "$1" in
    "")
      if [[ "$LOGFILE" == /dev/null ]]
      then
        echo "Verbosity is off"
      else
        echo "Verbosity is on"
      fi
      exit 0;
      ;;
    "on")
      LOGFILE=$(tty)
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
  s1="LOGFILE="
  if [[ $CONFIGFILE = *"$s1"* ]]
  then
    sed -i "s@^$s1.*\$@$s1$LOGFILE@" "$CONFIGFILE"
  else
    echo -e "$s1$LOGFILE\n" >> "$CONFIGFILE"
  fi
}

function verbose_help {
  echo ""
  echo "Usage: $(basename "$0") verbose <on|off>"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") verbose"
  echo "      Verbosity is off"
  echo ""
  echo "  $(basename "$0") verbose on"
  echo "      Successfully enabled verbosity"
  echo ""
  echo "  $(basename "$0") verbose off"
  echo "      Successfully disabled verbosity"
  echo ""
}
