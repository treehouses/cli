function wifimain {
  local wifinetwork wifipassword wifiaddr
  checkrpi
  checkroot
  checkargn $# 3
  if [ -z "$1" ]; then
    log_and_exit1 "Error: name of the network missing"
  fi

  wifinetwork=$1
  wifipassword=$2

  if [ -n "$wifipassword" ]
  then
    if [ ${#wifipassword} -lt 8 ]
    then
      log_and_exit1 "Error: password must have at least 8 characters"
    fi
  fi

  if [ -v hide ]; then
    hide="_hidden"
  fi    

  cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
  cp "$TEMPLATES/network/wlan0/default" /etc/network/interfaces.d/wlan0
  cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
  cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf
  cp "$TEMPLATES/network/dnsmasq/default" /etc/dnsmasq.conf
  cp "$TEMPLATES/rc.local/default" /etc/rc.local

  cp "$TEMPLATES/network/10-wpa_supplicant" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
  rm -rf /etc/udev/rules.d/90-wireless.rules

  if [[ -n "$3" ]]; then
    echo "    wpa-driver wext" >> /etc/network/interfaces.d/wlan0
  fi

  {
    echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev"
    echo "update_config=1"
    echo "country=$WIFICOUNTRY"
  } > /etc/wpa_supplicant/wpa_supplicant.conf

  if [ -z "$wifipassword" ]; then
    {
      echo "network={"
      echo "  ssid=\"$wifinetwork\""
      echo "  key_mgmt=NONE"
      if [ -v hide ]; then
        echo " scan_ssid=1"
      fi
      echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi
    wifiaddr=$(networkmode info | grep -oP -m1 '(?<=ip: ).*?(?=,)')
    if  [ ! -v hide ]; then
      echo "connected to open network; our wifi ip: $wifiaddr"
    else
      echo "connected to hidden open network; our wifi ip: $wifiaddr"
    fi  
  elif [[ -n "$wifipassword" ]] && [[ -v hide ]]; then
    {
    echo "network={"
    echo "  ssid=\"$wifinetwork\""
    echo "  scan_ssid=1"
      if [ -z "$3" ]; then
        echo "  key_mgmt=WPA-PSK"
        echo "  psk=\"$wifipassword\""
      else
        echo "  identity=\"${3}\""
        echo "  password=\"${wifipassword}\""
        echo "  key_mgmt=WPA-EAP"
        echo "  eap=PEAP"
        echo "  phase1=\"peaplabel=0\""
        echo "  phase2=\"auth=MSCHAPV2\""
      fi
    echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi  
    wifiaddr=$(networkmode info | grep -oP -m1 '(?<=ip: ).*?(?=,)')
    echo "connected to hidden password network; our wifi ip: $wifiaddr"
  else
    if [ -z "$3" ]; then
      wpa_passphrase "$wifinetwork" "$wifipassword" >> /etc/wpa_supplicant/wpa_supplicant.conf
    else
    {
      echo "network={"
      echo "  ssid=\"${wifinetwork}\""
      echo "  identity=\"${3}\""
      echo "  password=\"${wifipassword}\""
      echo "  key_mgmt=WPA-EAP"
      echo "  eap=PEAP"
      echo "  phase1=\"peaplabel=0\""
      echo "  phase2=\"auth=MSCHAPV2\""
      echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
    fi
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi
    wifiaddr=$(networkmode info | grep -oP -m1 '(?<=ip: ).*?(?=,)')
    echo "connected to password network; our wifi ip: $wifiaddr"
  fi

  echo "wifi" > /etc/network/mode
}

function wifi {
  wifimain "$@"
}

function wifi_help {
  echo
  echo "Usage: $BASENAME wifi <ESSID> [password] [identity]"
  echo
  echo "Connects to a wifi network"
  echo
  echo "Example:"
  echo "  $BASENAME wifi home homewifipassword"
  echo "      Connects to a wifi network named 'home' with password 'homewifipassword'."
  echo
  echo "  $BASENAME wifi yourwifiname"
  echo "      Connects to an open wifi network named 'yourwifiname'."
  echo
  echo "  $BASENAME wifi home homewifipassword identity"
  echo "      Connects to an Enterprise (WPA-EAP) wifi network named 'home' with user 'identity' and user password 'homewifipassword'."
  echo
}
