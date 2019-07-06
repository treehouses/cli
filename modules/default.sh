#!/bin/bash

function default {
  if [ "$1" == "notice" ] ; then
    default_notice
    echo 'Success: the message has been reset to default';
    exit 0
  fi

  if [ "$1" == "tunnel" ] ; then
    default_tunnel
    echo 'Success: the tunnel mode has been reset to default, please reboot your device';
    exit 0
  fi

  if [ "$1" == "network" ] ; then
    default_network
    echo 'Success: the network mode has been reset to default, please reboot your device';
    exit 0
  fi

  rename "raspberrypi" > /dev/null 2>/dev/null
  default_notice 
  default_tunnel
  default_network
  echo 'Success: the rpi has been reset to default, please reboot your device'
}

function default_network {
  cp "$TEMPLATES/network/interfaces/default" "/etc/network/interfaces"
  cp "$TEMPLATES/network/wpa_supplicant" "/etc/wpa_supplicant/wpa_supplicant.conf"
  cp "$TEMPLATES/rc.local/default" "/etc/rc.local"
  cp "$TEMPLATES/network/dnsmasq/default" "/etc/dnsmasq.conf"
  cp "$TEMPLATES/network/dhcpcd/default" "/etc/dhcpcd.conf"

  cp "$TEMPLATES/network/10-wpa_supplicant" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
  rm -rf /etc/udev/rules.d/90-wireless.rules

  rm -rf /etc/hostapd.conf
  rm -rf /etc/network/interfaces.d/*
  rm -rf /etc/rpi-wifi-country

  stop_service hostapd
  stop_service dnsmasq
  disable_service hostapd
  disable_service dnsmasq

  rm -rf /etc/network/up-bridge.sh
  rm -rf /etc/network/eth0-shared.sh
  rm -rf /etc/network/mode

  case $(detectrpi) in
    RPIZ|RPIZW)
      {
        echo "auto usb0"
        echo "allow-hotplug usb0"
        echo "iface usb0 inet ipv4ll"
      } > /etc/network/interfaces.d/usb0
      ;;
  esac
  
  reboot_needed
}

function default_tunnel {
  treehouses tor destroy > /dev/null
  treehouses openvpn off > /dev/null
  treehouses sshtunnel remove > /dev/null
}

function default_notice {
  treehouses tor notice off > /dev/null
  treehouses openvpn notice off > /dev/null
  treehouses sshtunnel notice delete > /dev/null
}


function default_help {
  echo ""
  echo "Usage: $(basename "$0") default [network]"
  echo ""
  echo "Resets the raspberry pi to default."
  echo "You can also just default the network by specifying it."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") default"
  echo "      This will allow you to return back to the original configuration for all the services and settings which were set for the image when it was first installed."
  echo "      This will not delete any new files you created."
  echo ""
  echo "  $(basename "$0") default network"
  echo "      This will return the network back to the original configuration of when installed."
  echo "      This will not delete any new files you created."
  echo ""
  echo "  $(basename "$0") default tunnel"
  echo "      This will return the tunnel back to the original configuration of when installed."
  echo "      This will not delete any new files you created."
  echo ""
  echo "  $(basename "$0") default notice"
  echo "      This will return the message back to its original configuration of when installed."
  echo "      This will not delete any new files you created."
  echo ""
}
