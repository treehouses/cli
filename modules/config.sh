# updates config variables "LOG" "1" Requires root
function conf_var_update() {
  if [[ -f "$CONFIGFILE" && $(cat $CONFIGFILE) = *"$1"* ]]
  then
    sed -i "s@^$1=.*\$@$1=$2@" "$CONFIGFILE"
  else
    echo -e "$1=$2" >> "$CONFIGFILE"
  fi
  sync;
}

function config {
  local varname
  checkroot
  checkargn $# 3
  case "$1" in
    "")
      if [[ -f "$CONFIGFILE" ]]; then
        echo "$(<$CONFIGFILE)"
      else
        echo $"Error: config file is empty; no variables to show"
        exit 1
      fi
    ;;
    update)
      if [ -z "$2" ] || [ -z "$3" ]; then
        echo $"Error: missing varname or varvalue"
        exit 1
      fi
      conf_var_update "$2" "$3"
      echo "Successfully updated variable"
    ;;
    add)
      if [ -z "$2" ] || [ -z "$3" ]; then
        echo $"Error: missing varname or varvalue"
        exit 1
      fi
      conf_var_update "$2" "$3"
      echo "Successfully added variable"
    ;;
    delete)
      checkargn $# 2
      varname="$2"
      if [ -z "$2" ]; then
        echo $"Error: missing varname"
        exit 1
      fi
      if [[ -f "$CONFIGFILE" && $(cat $CONFIGFILE) = *"$2"* ]]; then
        sed -i '/'"$varname"'=/d' "$CONFIGFILE"
        sync;
        echo "Successfully deleted variable"
      else
        echo $"Error: $2 doesn't exist; please run 'treehouses config' to show all variables"
        exit 1
      fi
    ;;
    clear)
      checkargn $# 1
      rm -f $CONFIGFILE
      echo "Successfully cleared config"
    ;;
    *)
      echo $"Error: only 'update' 'add' 'delete', and 'clear' options are supported"
      exit 1
    ;;
  esac
}

function config_help {
  echo
  echo "Usage: $BASENAME config [update|add|delete|clear]"
  echo
  echo "commands for interacting with config file"
  echo
  echo "Example:"
  echo "  $BASENAME config"
  echo "      Print list of config variables and values"
  echo
  echo "  $BASENAME config update varname value"
  echo "      update value of variable in config file"
  echo
  echo "  $BASENAME config add varname value"
  echo "      adds variable to config file"
  echo
  echo "  $BASENAME config delete varname"
  echo "      removes variable from config file"
  echo
  echo "  $BASENAME config clear"
  echo "      deletes config file"
  echo
}
