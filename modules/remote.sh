function remote {
  local option results
  checkroot
  checkrpi
  checkargn $# 2
  option="$1"

  if [ "$option" = "status" ]; then
    results=""
    results+="$(internet) "
    results+="$(bluetooth mac) "
    results+="$(image) "
    results+="$(version) "
    results+="$(detectrpi)"

    echo ${results}
  elif [ "$option" = "upgrade" ]; then
    upgrade --check
  elif [ "$option" = "services" ]; then
    if [ "$2" = "available" ]; then
      results="Available: "
      results+="$(services available)"

      echo ${results}
    elif [ "$2" = "installed" ]; then
      results="Installed: "
      results+="$(services installed)"

      echo ${results}
    elif [ "$2" = "running" ]; then
      results="Running: "
      results+="$(services running)"

      echo ${results}
    fi
  elif [ "$option" = "version" ]; then
    if [ -z "$2" ]; then
      echo "version number required"
      echo "usage: $BASENAME remote version <version_number>"
      exit 1
    fi
    if ! [[ "$2" =~ ^[0-9]+$ ]]; then
      echo "Error: not a number"
      exit 1
    fi
    if [ "$2" -ge "$(node -p "require('$SCRIPTFOLDER/package.json').remote")" ]; then
      echo "version: true"
    else
      echo "version: false"
    fi
  elif [ "$option" = "commands" ]; then
    source $SCRIPTFOLDER/_treehouses && _treehouses_complete 2>/dev/null
    echo "$every_command"
  else
    echo "unknown command option"
    echo "usage: $BASENAME remote [status | upgrade | services | version | commands]"
  fi
}

function remote_help {
  echo
  echo "Usage: $BASENAME remote [status | upgrade | services | version | commands]"
  echo
  echo "Returns a string representation of the current status of the Raspberry Pi"
  echo "Used for Treehouses Remote"
  echo
  echo "$BASENAME remote status"
  echo "<internet> <bluetooth mac> <image> <version> <detectrpi>"
  echo "     │            │           │        │          │"
  echo "     │            │           │        │          └── model number of rpi"
  echo "     │            │           │        └───────────── current cli version"
  echo "     │            │           └────────────────────── current treehouses image version"
  echo "     │            └────────────────────────────────── bluetooth mac address"
  echo "     └─────────────────────────────────────────────── internet connection status"
  echo
  echo "$BASENAME remote upgrade"
  echo "true if an upgrade is available"
  echo "false otherwise"
  echo
  echo "$BASENAME remote services [available | installed | running]"
  echo "Available: | Installed: | Running: <list of services>"
  echo
  echo "$BASENAME remote version <version_number>"
  echo "true if <version_number> >= \"remote_min_version\" in package.json"
  echo "false otherwise"
  echo
  echo "$BASENAME remote commands"
  echo "returns a list of all commands for tab completion"
  echo
}
