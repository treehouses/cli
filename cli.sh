#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"
SCRIPTARGNUM=$#

for f in $SCRIPTFOLDER/modules/*
do
  source "$f"
  cmd=$(basename "$f")
  cmd=${cmd%%.*}
  if [ "$cmd" = "$1" ]; then
    find=1
  fi
done
if [ "$find" = 1 ]; then
  start_spinner
  eval "$@"
else
  help
fi

if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
if [[ ! -v NOSPIN ]]; then
  tput cvvis
fi
