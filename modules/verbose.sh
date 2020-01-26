#!/bin/bash

function verbose {
  case "$1" in
    "")
      if [[ "$LOGFILE" == /dev/null ]]
      then
        logit "Verbosity is off"
      else
        logit "Verbosity is on"
      fi
      exit 0;
      ;;
    "on")
      LOGFILE=$(tty)
      logit "Successfully enabled verbosity"
      ;;
    "off")
      LOGFILE=/dev/null
      logit "Successfully disabled verbosity"
      ;;
    *)
      logit "Error: only 'on' and 'off' options are supported";
      exit 1;
      ;;
  esac
  s1="LOGFILE="
  if [[ $(cat $CONFIGFILE) = *"$s1"* ]]
  then
    sed -i "s@^$s1.*\$@$s1$LOGFILE@" "$CONFIGFILE"
  else
    echo -e "$s1$LOGFILE" >> "$CONFIGFILE"
  fi
}

function verbose_help {
  echo
  echo "Usage: $(basename "$0") verbose <on|off>"
  echo
  echo "Example:"
  echo "  $(basename "$0") verbose"
  echo "      Verbosity is off"
  echo
  echo "  $(basename "$0") verbose on"
  echo "      Successfully enabled verbosity"
  echo
  echo "  $(basename "$0") verbose off"
  echo "      Successfully disabled verbosity"
  echo
}
