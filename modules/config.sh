#!/bin/bash

# config constants
SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
CONFIGFILE=/etc/treehouses.conf
BASENAME=$(basename "$0")
TEMPLATES="$SCRIPTFOLDER/templates"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# config variables (defaults)
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
