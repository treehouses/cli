#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"

for f in $SCRIPTFOLDER/modules/*
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
