#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"

if [[ "$1" == "-"* ]]; then
  if [ ${#1} -gt 2 ] || [ ${#1} -lt 2 ] || [[ ${1:1} != *[[abefhkmnptuvxBCHP]* ]]; then
    echo "Error: option not supported please see 'set --help' for available options"
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
  if [ "$cmd" = "$1" ] && [ "$1" != "globals" ] && [ "$1" != "config" ]; then
    find=1
  fi
done
if [ "$find" = 1 ]; then
  eval "$@"
else
  help
fi

if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
