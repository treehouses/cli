#!/bin/bash

# Config file where config variables are saved (optional)
CONFIGFILE=/etc/treehouses.conf

# Config variables (defaults)
LOGFILE=/dev/null
LOG=0

if [[ -f "$CONFIGFILE" ]]; then
  source "$CONFIGFILE"
fi

# updates config variables "LOG" "1" Requires root
function conf_var_update() {
  if [[ $(cat $CONFIGFILE) = *"$1"* ]]
  then
    sed -i "s@^$1=.*\$@$1=$2@" "$CONFIGFILE"
  else
    echo -e "$1=$2" >> "$CONFIGFILE"
  fi
  sync;
}
