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

function get_ipv4_ip {
  interface="$1"
  if [ "$interface" == "ap0" ]; then
    echo $(/sbin/ip -o -4 addr list "$interface" | awk '{print $4}' | sed '2d' | cut -d/ -f1)
  else
    echo $(/sbin/ip -o -4 addr list "$interface" | awk '{print $4}' | cut -d/ -f1)
  fi
}