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
  elif [ "$tag" == "--check" ];
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
  # added to replace to-be-deprecated `treehouses upgrade -f` command
  elif [ "$tag" == "force" ];
  then
    npm install -g "@treehouses/cli@-f"
  else
    npm install -g "@treehouses/cli@${tag}"
  fi
}

function upgrade_help {
  echo
  echo "Usage: $BASENAME upgrade [tag] [--check]"
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
}
