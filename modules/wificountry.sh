#!/bin/bash

function wificountry {
  country=$1

  if [ -e /etc/wpa_supplicant/wpa_supplicant.conf ]; then
      if grep -q "^country=" /etc/wpa_supplicant/wpa_supplicant.conf ; then
          sed -i --follow-symlinks "s/^country=.*/country=$country/g" /etc/wpa_supplicant/wpa_supplicant.conf
      else
          sed -i --follow-symlinks "1i country=$country" /etc/wpa_supplicant/wpa_supplicant.conf
      fi
  else
      echo "country=$country" > /etc/wpa_supplicant/wpa_supplicant.conf
  fi
  iw reg set "$country" 2> "$LOGFILE";

  if [ -f /run/wifi-country-unset ] && hash rfkill 2> "$LOGFILE"; then
      rfkill unblock wifi
  fi

  echo "$country" > /etc/rpi-wifi-country

  echo "Success: the wifi country has been set to $country"
}

function wificountry_help {
  echo
  echo "Usage: $BASENAME wificountry <country>"
  echo
  echo "Sets the wireless interface country. Required on rpi 3b+ in order to get wifi working."
  echo
  echo "Example:"
  echo "  $BASENAME wificountry US"
  echo "      This will set the wifi country to 'US'."
  echo "      This configuration is used in all commands (wifi, bridge, hotspot)."
  echo
}