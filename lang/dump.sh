#!/bin/bash
# NOTE: Only run in this directory
# This looks for strings marked for localization
# ex. $"text here"
# Then this script adds any new ones found
# to the already create .po files
for f in ../modules/*.sh
do
  cmd=${f%.*}
  cmd=${cmd##*/}
  for d in */ ; do
    bash --dump-po-strings $f > ./${cmd}.pot
    find . -maxdepth 1 -size 0c -exec rm {} \;
    if [ -f ./${cmd}.pot ]; then
      msguniq ./${cmd}.pot -o ./${cmd}.pot
      msgmerge --update ./${d}${cmd}.po ./${cmd}.pot
    fi
    rm -rf ./*.pot
    find . -type f -name '*~*' -exec rm -f {} +
  done
done
