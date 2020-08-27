function start_service {
  if [ "$(systemctl is-active "$1" 2>"$LOGFILE")" = "inactive" ]
  then
    systemctl start "$1" >"$LOGFILE" 2>"$LOGFILE"
  fi
}

function restart_service {
  systemctl stop "$1" >"$LOGFILE" 2>"$LOGFILE"
  systemctl start "$1" >"$LOGFILE" 2>"$LOGFILE"
}

function stop_service {
  if [ "$(systemctl is-active "$1" 2>"$LOGFILE")" = "active" ]
  then
    systemctl stop "$1" >"$LOGFILE" 2>"$LOGFILE"
  fi
}

function enable_service {
  if [ "$(systemctl is-enabled "$1" 2>"$LOGFILE")" = "disabled" ]
  then
    systemctl enable "$1" >"$LOGFILE" 2>"$LOGFILE"
  fi
}

function disable_service {
  if [ "$(systemctl is-enabled "$1" 2>"$LOGFILE")" = "enabled" ]
  then
    systemctl disable "$1" >"$LOGFILE" 2>"$LOGFILE"
  fi
}

function checkroot {
  if [ "$(id -u)" -ne 0 ];
  then
      echo "Error: Must be run with root permissions"
      exit 1
  fi
}

function checkrpi {
  if [ "$(detectrpi)" == "nonrpi" ];
  then
    echo "Error: Must be run with rpi system"
    exit 1
  fi
}

function checkargn {
  local helpfunc
  if [[ $1 -gt $2 ]]; then
    echo "Error: Too many arguments."
    helpfunc="$(echo $SCRIPTARGS | cut -d' ' -f1)"
    if [[ $helpfunc = "help" ]]; then
      help
    else
      eval "${helpfunc}_help"
    fi
    exit 1
  fi
}

function checkrpiwireless {
  checkrpi
  if [[ "$(detect bluetooth)" == "false" ]]; then
    echo "Error: no Bluetooth device detected"
    exit 1
  fi
}

function checkinternet {
  if [[ $(internet) == "false" ]]; then
    echo "Error: no Internet found"
    exit 1
  fi
}

function checkwifi {
  if iwconfig wlan0 | grep -q "ESSID:off/any"; then
    echo "wifi is not connected"
    echo "check SSID and password and try again"
    exit 1
  fi
}

function restart_hotspot {
  restart_service dhcpcd || true
  ifdown wlan0 || true
  sleep 1 || true
  ifup wlan0 || true
  sysctl net.ipv4.ip_forward=1 || true
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE || true
  iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT || true
  iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT || true
  restart_service dnsmasq || true
  restart_service hostapd || true
  enable_service hostapd || true
  enable_service dnsmasq || true
}

function restart_ethernet {
  ifup eth0 || true
  ifdown eth0 || true
  sleep 1
  ifup eth0 || true
}

function restart_wifi {
  systemctl disable hostapd || true
  systemctl disable dnsmasq || true
  restart_service dhcpcd
  stop_service hostapd
  stop_service dnsmasq
  ifup wlan0 || true
  ifdown wlan0 || true
  sleep 1
  ifup wlan0 || true
}

function clean_var {
  if echo "$1" | grep -q "\-\-ip="; then
    echo
  else
    echo "$1"
  fi
}

function reboot_needed {
  if [ ! -f "/etc/reboot-needed.sh" ]; then
    cp "$TEMPLATES/reboot-needed.sh" /etc/
    chmod +x /etc/reboot-needed.sh
  fi

  touch "/etc/reboot-needed"

  if ! grep -q "@reboot root /etc/reboot-needed.sh" "/etc/crontab" 2>"$LOGFILE" ; then
    echo "@reboot root /etc/reboot-needed.sh" >> "/etc/crontab"
  fi
}

function get_ipv4_ip {
  local interface
  interface="$1"
  if iface_exists "$interface"; then
    if [ "$interface" == "ap0" ]; then
      /sbin/ip -o -4 addr list "$interface" | grep -v "avahi" | awk '{print $4}' | sed '2d' | cut -d/ -f1
    else
      /sbin/ip -o -4 addr list "$interface" | grep -v "avahi" | awk '{print $4}' | cut -d/ -f1
    fi
  fi
}

function iface_exists {
  local interface
  interface="$1"
  if grep -q "$interface:" < /proc/net/dev ; then
    return 0
  else
    return 1
  fi
}

function check_missing_packages {
  local missing_deps
  missing_deps=()
  for command in "$@"; do
    if [ "$(dpkg-query -W -f='${Status}' $command 2>"$LOGFILE" | grep -c 'ok installed')" -eq 0 ]; then
      missing_deps+=( "$command" )
    fi
  done

  if (( ${#missing_deps[@]} > 0 )) ; then
    echo "Missing required programs: ${missing_deps[*]}"
    echo "On Debian/Ubuntu try 'sudo apt install ${missing_deps[*]}'"
    exit 1
  fi
}

function check_missing_binary {
  missing_binary=$1
  install_instruction=$2
  if [[ $(which $missing_binary) == "" ]]; then
    echo "\"$missing_binary\" not found, please install first"
    exit 1
  else
    "$install_instruction"="Trying to install $missing_binary...\nSearch for it with command 'dpkg -l | grep $missing_binary'\nThen, install it with command 'sudo apt install $missing_binary'"
    echo -e "$install_instruction"
  fi
}

# Credits: https://www.shellscript.sh/tips/spinner/
function spinner() {
  spinner="/|\\-/|\\-"
  tput civis
  while :
  do
    for i in $(seq 0 7)
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 0.5
    done
  done
}

function kill_spinner() {
  if [[ "$KILLDONE" != 1 ]]; then
    kill -9 $SPINPID
    KILLDONE=1
  fi
  tput cvvis
  return
}

function start_spinner() {
  local tree carg cstring
  tree=$(pstree -ps $$)
  cstring="discover wifi wifihidden bridge container upgrade
           led clone restore burn services speedtest usb"
  carg="$(echo $SCRIPTARGS | cut -d' ' -f1)"
  if [[ $tree == *"python"* ]] || [[ $tree == *"cron"* ]] || \
     [[ ! "$cstring" == *"$carg"* ]]
  then
    NOSPIN=1
    return
  fi
  set -m
  trap kill_spinner {0..15} SIGTSTP
  spinner &
  SPINPID=$!
  disown
}
