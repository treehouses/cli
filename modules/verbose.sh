#!/bin/bash

# $LOGFILE is used like so systemctl disable "$1" >"$LOGFILE" 2>"$LOGFILE"
# /dev/null is the void (output and errors vanish) $(tty) is the terminal screen
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
  conf_var_update "LOGFILE" "$LOGFILE"
}

function verbose_help {
  echo
  echo "Usage: $BASENAME verbose <on|off>"
  echo
  echo "Example:"
  echo "  $BASENAME verbose"
  echo "      Verbosity is off"
  echo
  echo "  $BASENAME verbose on"
  echo "      Successfully enabled verbosity"
  echo
  echo "  $BASENAME verbose off"
  echo "      Successfully disabled verbosity"
  echo
}
