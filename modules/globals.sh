#!/bin/bash
TEMPLATES="$SCRIPTFOLDER/templates"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function start_service {
  if [ "$(systemctl is-active "$1" 2>/dev/null)" = "inactive" ]
  then
    systemctl start "$1" >/dev/null 2>/dev/null
  fi
}

function restart_service {
  systemctl stop "$1" >/dev/null 2>/dev/null
  systemctl start "$1" >/dev/null 2>/dev/null
}

function stop_service {
  if [ "$(systemctl is-active "$1" 2>/dev/null)" = "active" ]
  then
    systemctl stop "$1" >/dev/null 2>/dev/null
  fi
}

function enable_service {
  if [ "$(systemctl is-enabled "$1" 2>/dev/null)" = "disabled" ]
  then
    systemctl enable "$1" >/dev/null 2>/dev/null
  fi
}

function disable_service {
  if [ "$(systemctl is-enabled "$1" 2>/dev/null)" = "enabled" ]
  then
    systemctl disable "$1" >/dev/null 2>/dev/null
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
	vagrant_var=$(uname -ar | cut -d ' ' -f 2) # check if it is a vagrant box 
  if [[ "$(detectrpi)" == "nonrpi"  &&  ! "$vagrant_var" == "template" ]]; 
  then
    echo "Error: Must be run with rpi system"
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
    echo ""
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

  if ! grep -q "@reboot root /etc/reboot-needed.sh" "/etc/crontab" 2>/dev/null ; then
    echo "@reboot root /etc/reboot-needed.sh" >> "/etc/crontab"
  fi
}

function get_ipv4_ip {
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
  interface="$1"
  if grep -q "$interface:" < /proc/net/dev ; then
    return 0
  else
    return 1
  fi
}

function check_missing_packages {
  missing_deps=()
  for command in "$@"; do
    if ! type $command &>/dev/null ; then
        missing_deps+=( "$command" )
    fi
  done

  if (( ${#missing_deps[@]} > 0 )) ; then
      echo "Missing required programs: ${missing_deps[*]}"
      echo "On Debian/Ubuntu try 'sudo apt install ${missing_deps[*]}'"
      exit 1
  fi
}
