#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"
TEMPLATES="$SCRIPTFOLDER/templates"
SERVICES="$SCRIPTFOLDER/services"
CONFIGFILE=/etc/treehouses.conf
BASENAME=$(basename "$0")
LOGFILE=/dev/null
LOG=0
BLOCKER=0
token="adfab56b2f10b85f94db25f18e51a4b465dbd670"
channel="https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# set on ../templates/network/tor_report.sh
if [ ! -z "$gitter_channel" ]; then
  channel="$gitter_channel"
fi

if [[ -f "$CONFIGFILE" ]]; then
  source "$CONFIGFILE"
fi

if [[ "$1" == "-"* ]]; then
  if [ ${#1} -gt 2 ] || [ ${#1} -lt 2 ] || [[ ${1:1} != *[[abefhkmnptuvxBCHP]* ]]; then
    echo "Error: $1 option not supported please use [-abefhkmnptuvxBCHP] see 'set --help' for usage"
    exit 1
  else
    set "$1"
    shift
  fi
fi

for f in $SCRIPTFOLDER/modules/*.sh
do
  source "$f"
  cmd=$(basename "$f")
  cmd=${cmd%%.*}
  if [ "$cmd" = "$1" ] && [ "$1" != "globals" ]; then
    find=1
  fi
done
if [ "$find" = 1 ]; then
  "$@"
else
  help
fi

if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
