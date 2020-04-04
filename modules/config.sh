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
