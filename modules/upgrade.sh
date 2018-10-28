#!/bin/bash

function upgrade {
  tag=$1
  if [ -z "$tag" ];
  then
      if ! [[ "$*" = *"-f"* ]];
      then
          last_version=$(npm show @treehouses/cli version)
          if [ "$last_version" = "$(version)" ];
          then
              echo "$(basename "$0") is already up to date."
              exit
          fi
      fi
      npm install -g '@treehouses/cli@latest'
  else
      if [[ ${tag} =~ [0-9].*\.[0-9].*\.[0-9].*(-\\w).* ]]; then
        npm install -g "@treehouses/cli@${tag}"
      else
        npm install -g "@treehouses/cli@latest";
      fi
  fi
}

function upgrade_help {
  echo ""
  echo "Usage: $(basename "$0") upgrade [-f] [tag]"
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
  echo " $(basename "$0") upgrade tag"
  echo "    This will upgrade the $(basename "$0") package to the version with the specified tag"
  echo ""
}