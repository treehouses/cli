function upgrade {
  local tag last_version
  tag=$1
  if [ -z "$tag" ] && [ "$tag" != "--check" ];
  then
    checkroot
    if ! [[ "$*" = *"-f"* ]];
    then
      last_version=$(npm show @treehouses/cli version)
      if [ "$last_version" = "$(version)" ];
      then
          log_and_exit0 "$BASENAME is already up to date."
      fi
    fi
    npm install -g '@treehouses/cli@latest'
  elif [ "$tag" == "--check" ];
  then
    if [ "$(internet)" == "false" ];
    then
      log_and_exit0 "false"
    fi

    last_version=$(npm show @treehouses/cli version)
    if [ "$last_version" = "$(version)" ];
    then
      log_and_exit0 "false"
    fi

    logit "true $last_version"
  else
    npm install -g "@treehouses/cli@${tag}"
  fi
}

function upgrade_help {
  echo
  echo "Usage: $BASENAME upgrade [-f] [tag] [--check]"
  echo 
  echo "Upgrades $BASENAME package using npm"
  echo
  echo "Example:"
  echo " $BASENAME upgrade"
  echo "    This will upgrade the $BASENAME package using npm and will try to install the latest version of $BASENAME running on your system"
  echo "    If the latest version if installed it will not try to reinstall it"
  echo
  echo " $BASENAME upgrade -f"
  echo "    This will do the same as upgrade, but the version will not be checked. Meaning that this will force the installation of the latest version"
  echo
  echo " $BASENAME upgrade tag"
  echo "    This will upgrade the $BASENAME package to the version with the specified tag"
  echo
  echo " $BASENAME upgrade --check"
  echo "    checks if there is a new version of the package, outputs false if there isnt, outputs true + version if there is"
  echo
}
