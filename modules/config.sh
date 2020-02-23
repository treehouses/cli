# global config constants
CONFIGFILE=/etc/treehouses.conf
BASENAME=$(basename "$0")
TEMPLATES="$SCRIPTFOLDER/templates"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# global config variables (defaults)
LOGFILE=/dev/null
LOG=0
BLOCKER=0

if [[ -f "$CONFIGFILE" ]]; then
  source "$CONFIGFILE"
fi

# writes bash trace to screen and to syslog
if [[ "$LOG" == "max" ]]; then
  set -x
  exec 1> >(tee >(logger -t @treehouses/cli)) 2>&1
fi

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

# Credits: https://www.shellscript.sh/tips/spinner/
function spin() {
  spinner="/|\\-/|\\-"
  while :
  do
    for i in $(seq 0 7)
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 1
    done
  done
}
# Run spin in background and kill upon cli exit
spin &
SPIN_PID=$!
trap 'kill -9 $SPIN_PID' $(seq 0 15)
