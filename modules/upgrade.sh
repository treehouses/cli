#!/bin/bash

function upgrade {
  if ! [[ "$*" = *"-f"* ]];
  then
    last_version=$(npm show @treehouses/cli version)
    if [ "$last_version" = "$(version)" ];
    then
      echo "$(basename "$0") is already up to date."
      exit
    fi
  fi
  npm install -g '@treehouses/cli'
}

function upgrade_help {
  echo ""
  echo "Usage: $(basename "$0") upgrade [-f]"
  echo "" 
  echo "Upgrades $(basename "$0") package using npm"
  echo ""
  echo "Example:"
  echo " $(basename "$0") upgrade"
  echo "    This will upgrade the $(basename "$0") package using npm and will try to install the latest version of $(basename "$0") running on your system"
  echo "    If the latest version if installed it will not try to reinstall it"
  echo ""
  echo " $(basename "$0") upgrade -f"
  echo "    This will do the same as upgrade, but the version will not be checked. Meaning that this will force the installation of the latest version"
  echo ""
}