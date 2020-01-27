#!/bin/bash

CONFIGFILE=/etc/treehouses.conf

LOGFILE=/dev/null
LOG=0

if [[ -f "$CONFIGFILE" ]]; then
  source "$CONFIGFILE"
fi

function conf_var_update() {
  if [[ -f "$CONFIGFILE" && $(cat $CONFIGFILE) = *"$1"* ]]
  then
    sudo sed -i "s@^$1=.*\$@$1=$2@" "$CONFIGFILE"
  else
    echo -e "$1=$2" >> "$CONFIGFILE"
  fi
  sync;
}
