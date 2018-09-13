#!/bin/bash

function default {
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
  rename "raspberrypi" > /dev/null 2>/dev/null
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

  echo 'Success: the rpi has been reset to default, please reboot your device'
}

function default_help {
  echo ""
  echo "Usage: $(basename "$0") default"
  echo ""
  echo "Resets the raspberry pi to default"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") default"
  echo "      This will allow you to return back to the original configuration for all the services and settings which were set for the image when it was first installed."
  echo "      This will not delete any new files you created."
  echo ""
}
