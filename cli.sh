#!/bin/bash

SCRIPTPATH=$(realpath "$0")
SCRIPTFOLDER=$(dirname "$SCRIPTPATH")
SCRIPTARGS="$*"
SCRIPTARGNUM=$#

for f in $SCRIPTFOLDER/modules/*; do source "$f"; done
for f in $SCRIPTFOLDER/modules/*
do
  cmd=$(basename "$f")
  cmd=${cmd%%.*}
  if [ "$cmd" = "$1" ]; then
    find=1
    eval $@
    break
  fi
done
if [ "$find" != 1 ]; then
  help
fi

if [ $? -eq 0 ]; then
  logit "$SCRIPTARGS" "1"
fi
