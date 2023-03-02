#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"
TEMPLATES="$SCRIPTFOLDER/templates"
SERVICES="$SCRIPTFOLDER/services"
MAGAZINES="$SCRIPTFOLDER/magazines"
CONFIGFILE=/etc/treehouses.conf
BASENAME=$(basename "$0")
WIFICOUNTRY="US"
LOGFILE=/dev/null
LOG=0
BLOCKER=0
chat="$(echo aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvCg== | openssl enc -d -pbkdf2 -a -salt -pass 'pass:I&l_v^diS%%repo')"
hook="$(echo MTA3OTk4MTM3MjU2MDY1NDM3Ni9nekVDbURXNXRmWEV3ZFlEZ3RYdF9mcmxMWl9Nbmo1QTYtX01iQkdLWXV0OHdfMTlod3VqcGc1X21lMmlkdXdkdUZfbAo= | openssl enc -d -pbkdf2 -a -salt -pass 'pass:I&l_v^diS%%repo')"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# set on ../templates/network/tor_report.sh
if [ ! -z "$discord_channel" ]; then
  chat="$discord_channel"
  hook=""
fi

if [[ -f "$CONFIGFILE" ]]; then
  source "$CONFIGFILE"
fi

if [[ "$LOG" == "max" ]]; then
  set -x
  exec 1> >(tee >(logger -t @treehouses/cli)) 2>&1
fi

for f in $SCRIPTFOLDER/modules/*.sh
do
  source "$f"
  cmd=${f##*/}
  cmd=${cmd%.*}
  if [ "$cmd" = "$1" ] && [ "$1" != "globals" ]; then
    find=1
  fi
done

if [ "$find" = 1 ]; then
  start_spinner
  "$@"
else
  help
fi

if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi

if [[ ! -v NOSPIN ]]; then
  tput cvvis
fi
