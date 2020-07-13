function upgrade {
  local tag last_version branch existed_in_remote
  checkargn $# 2
  checkinternet
  tag=$1
  if [ -z "$tag" ];
  then
    checkroot
    last_version=$(npm show @treehouses/cli version)
    if [ "$last_version" = "$(version)" ];
    then
      echo "$BASENAME is already up to date."
      exit
    fi
    npm install -g '@treehouses/cli@latest'
  elif [ "$tag" == "check" ] || [ "$tag" == "--check" ];
  then
    if [ "$(internet)" == "false" ];
    then
      echo "false"
      exit
    fi
    last_version=$(npm show @treehouses/cli version)
    if [ "$last_version" = "$(version)" ];
    then
      echo "false"
      exit
    fi
    echo "true $last_version"
  elif [ "$tag" == "force" ];
  then
    npm install -g -f "@treehouses/cli"
  elif [ "$tag" == "bluetooth" ]; then
    checkroot
    checkrpiwireless
    if [ "$2" = "" ]; then
      branch="master"
    else
      branch="$2"
      existed_in_remote=$(git ls-remote -h https://github.com/treehouses/control.git ${branch})
      if [[ -z ${existed_in_remote} ]]; then
        log_and_exit1 "Error: branch specified not found on bluetooth server repository"
      fi
    fi
    cp /usr/local/bin/bluetooth-server.py "/usr/local/bin/bluetooth-server.py.$(date +'%Y%m%d%H%m%S')"
    curl -s "https://raw.githubusercontent.com/treehouses/control/${branch}/server.py" -o /usr/local/bin/bluetooth-server.py
    sleep 5
    bluetooth restart
    echo "Successfully updated and restarted bluetooth server"
  elif [ "$tag" == "cli" ]; then
    checkroot
    if [ "$2" = "" ]; then
      branch="master"
    else
      branch="$2"
      existed_in_remote=$(git ls-remote -h https://github.com/treehouses/cli.git ${branch})
      if [[ -z ${existed_in_remote} ]]; then
        log_and_exit1 "Error: branch specified not found on cli repository"
      fi
    fi
    sudo npm install -g "https://github.com/treehouses/cli#${branch}" && echo "Successfully updated cli to $branch branch"
  else
    sudo npm install -g "@treehouses/cli@${tag}"
  fi
}

function upgrade_help {
  echo
  echo "Usage: $BASENAME upgrade [check|tag|cli|bluetooth]"
  echo
  echo "Upgrades $BASENAME package using npm"
  echo
  echo "Example:"
  echo " $BASENAME upgrade"
  echo "    This will upgrade the $BASENAME package using npm and will try to install the latest version of $BASENAME running on your system"
  echo "    If the latest version if installed it will not try to reinstall it"
  echo
  echo " $BASENAME upgrade tag"
  echo "    This will upgrade the $BASENAME package to the version with the specified tag"
  echo
  echo " $BASENAME upgrade force"
  echo "    This will upgrade the $BASENAME package to the version with the -f tag"
  echo
  echo " $BASENAME upgrade check"
  echo "    checks if there is a new version of the package, outputs false if there isn't, outputs true + version if there is"
  echo
  echo " $BASENAME upgrade bluetooth"
  echo "    This will upgrade the bluetooth server to the latest if internet is available and restart bluetooth"
  echo
  echo " $BASENAME upgrade bluetooth branchname"
  echo "    This will do the same as the above but use the 'branchname' branch on the bluetooth server repository"
  echo "    https://github.com/treehouses/control"
  echo
  echo " $BASENAME upgrade cli branchname"
  echo "    This will upgrade the cli to the specified 'branchname' branch on github"
  echo "    https://github.com/treehouses/cli"
  echo
}
