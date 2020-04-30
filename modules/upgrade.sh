function upgrade {
  local tag last_version
  checkargn $# 2
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
    checkargn $# 2
    npm install -g -f "@treehouses/cli@${2}"
  elif [ "$tag" == "bluetooth" ]; then
    checkargn $# 1
    checkroot
    checkwrpi
    checkinternet
    cp /usr/local/bin/bluetooth-server.py "/usr/local/bin/bluetooth-server.py.$(date +'%Y%m%d%H%m%S')"
    curl -s "https://raw.githubusercontent.com/treehouses/control/master/server.py" -o /usr/local/bin/bluetooth-server.py
    bluetooth restart &>"$LOGFILE"
    echo "Successfully updated and restarted bluetooth server"
  else
    npm install -g "@treehouses/cli@${tag}"
  fi
}

function upgrade_help {
  echo
  echo "Usage: $BASENAME upgrade [tag|bluetooth] [--check]"
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
  echo " $BASENAME upgrade force 1.11.4"
  echo "    This will upgrade the $BASENAME package to the version forcibly"

  echo " $BASENAME upgrade check"
  echo "    checks if there is a new version of the package, outputs false if there isn't, outputs true + version if there is"
  echo
  echo " $BASENAME upgrade bluetooth"
  echo "    This will upgrade the bluetooth server to the latest if internet is available and restart bluetooth"
  echo
}
