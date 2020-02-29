#!/bin/bash

# Share Wifi with Eth device

function addwifibridge {

  case "$1" in
    "on")

      checkwifi

      ip_address="192.168.2.1"
      netmask="255.255.255.0"

      sudo systemctl start network-online.target &> /dev/null

      sudo iptables -F
      sudo iptables -t nat -F
      sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
      sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
      sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

      sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

      sudo ifconfig eth0 $ip_address netmask $netmask

      # Remove default route created by dhcpcd
      sudo ip route del 0/0 dev eth0 &> /dev/null

      sudo systemctl stop dnsmasq

      sudo rm -rf /etc/dnsmasq.d/* &> /dev/null

      cp "$TEMPLATES/network/wifibridge" /etc/dnsmasq.d/custom-dnsmasq.conf

      sudo systemctl start dnsmasq

      echo "wifibridge" > /etc/network/mode
      ;;

    "off")
      cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
      cp "$TEMPLATES/network/wlan0/default" /etc/network/interfaces.d/wlan0
      cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
      cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf
      cp "$TEMPLATES/network/dnsmasq/default" /etc/dnsmasq.conf
      cp "$TEMPLATES/rc.local/default" /etc/rc.local

      cp "$TEMPLATES/network/10-wpa_supplicant" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
      rm -rf /etc/udev/rules.d/90-wireless.rules

      stop_service hostapd
      stop_service dnsmasq
      disable_service hostapd
      disable_service dnsmasq

      restart_wifi >"$LOGFILE" 2>"$LOGFILE"

      iptables-restore < templates/network/default_iptables

      echo "wifi" > /etc/network/mode
      ;;


    *)
      log_and_exit1 "ERROR: only on and off supported" "" "ERROR"
      ;;

  esac
}

function checkwifi {
  if iwconfig wlan0 | grep -q "ESSID:off/any"; then
    echo "Wifi is not connected."
    echo ""
    echo "A wifi connection is necessary to build the wifibridge."
    echo "Use the 'treehouses wifi' command to connect to wireless network."
    echo ""
    exit 1
  fi
}

function addwifibridge_help {
  echo ""
  echo "Forwards the WLAN signal to the ethernet port, sharing the signal with devices attached via ethernet."
  echo ""
  echo "Usage $BASENAME addwifibridge <on|off>"
  echo ""
  echo "Examples:"
  echo ""
  echo "$BASENAME addwifibridge on"
  echo "  Creates the wifi bridge."
  echo ""
  echo "$BASENAME addwifibridge off"
  echo "  Removes the wifi bridge."
}
