function log {
  case "$1" in
    "")
      if [[ "$LOG" == 0 ]]; then
        echo "Log is off"
      else
        echo "Log is on"
      fi
      exit 0
      ;;
    "0")
      LOG=0
      echo "Logging disabled"
      ;;
    "1")
      LOG=1
      echo "Logging enabled"
      ;;
    *)
      echo "Error: only '0' and '1' are supported"
      exit 1
      ;;
  esac
  s1="LOG="
  if [[ $CONFIGFILE = *"$s1"* ]]
  then
    sed -i "s@^$s1.*\$@$s1$LOG@" "$CONFIGFILE"
  else
    echo -e "$s1$LOG\n" >> "$CONFIGFILE"
  fi
}

