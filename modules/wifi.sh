function wifi {
  local wifinetwork wifipassword wificountry signal signalStrength
  checkrpi
  checkroot
  checkargn $# 3
  if [ -z "$1" ]; then
     echo "Error: name of the network missing"
    exit 1
  fi

  if [ "$1" == "status" ]; then
  # layman nomenclature for wifi signal strength
  #   perfect=(-10 ... -29)
  #   incredible=(-30 -31 -32 -33 -34 -35 -36 -37 -38 -39)
  #   excellent=(-40 -41 -42 -43 -44 -45 -46 -47 -48 -49)
  #   good=(-50 -51 -52 -53 -54 -55 -56 -57 -58 -59)
  #   okay=(-60 -61 -62 -63 -64 -65 -66 -67 -68 -69)
  #   poor=(-70 -71 -72 -73 -74 -75 -76 -77 -78 -79)
  #   bad=(-80 -81 -82 -83 -84 -85 -86 -87 -88 -89 -90)
  # display strength of signal in dBm and layman terms

  signal=$(iwconfig wlan0 | sed -n 's/.*\(Signal level=-.*\)/\1/p' | sed -e 's/Signal level=//g' | sed -e 's/dBm//g')
  signalStrength=$(iwconfig wlan0 | sed -n 's/.*\(Signal level=-.*\)/\1/p' | sed -e 's/Signal level=//g')
  case "$2" in
    "")
      #check if device has wifi
      if iwconfig wlan0 2>&1 | grep -q "No such device"; then
        echo "Error: no wifi device is present"
        exit 0
      fi
      #check if device is connected to wifi
      if iwconfig wlan0 | grep -q "ESSID:off/any"; then
        echo "Error: you are not on a wireless connection"
      else
        echo "Signal strength is $signalStrength"
        if [ "$signal" -gt -30 ] && [ "$signal" -lt -10 ] ; then
          echo "You have a perfect signal"
        fi
        if [ "$signal" -gt -40 ] && [ "$signal" -lt -29 ] ; then
          echo "You have an incredible signal"
        fi
        if [ "$signal" -gt -50 ] && [ "$signal" -lt -39 ] ; then
          echo "You have an excellent signal"
        fi
        if [ "$signal" -gt -60 ] && [ "$signal" -lt -49 ] ; then
          echo "You have a good signal"
        fi
        if [ "$signal" -gt -70 ] && [ "$signal" -lt -59 ] ; then
          echo "You have an okay signal"
        fi
        if [ "$signal" -gt -80 ] && [ "$signal" -lt -69 ] ; then
          echo "You have a poor signal"
        fi
        if [ "$signal" -gt -90 ] && [ "$signal" -lt -79 ] ; then
          echo "You have a bad signal"
        fi
      fi
      ;;
    "simple")
      if [ "$signal" -gt -30 ] && [ "$signal" -lt -10 ] ; then
        echo "You have a perfect signal"
      fi
      if [ "$signal" -gt -40 ] && [ "$signal" -lt -29 ] ; then
        echo "You have an incredible signal"
      fi
      if [ "$signal" -gt -50 ] && [ "$signal" -lt -39 ] ; then
        echo "You have an excellent signal"
      fi
      if [ "$signal" -gt -60 ] && [ "$signal" -lt -49 ] ; then
        echo "You have a good signal"
      fi
      if [ "$signal" -gt -70 ] && [ "$signal" -lt -59 ] ; then
        echo "You have an okay signal"
      fi
      if [ "$signal" -gt -80 ] && [ "$signal" -lt -69 ] ; then
        echo "You have a poor signal"
      fi
      if [ "$signal" -gt -90 ] && [ "$signal" -lt -79 ] ; then
        echo "You have a bad signal"
      fi
      ;;
    "dbm")
      echo "$signal"
      ;;
    "*")
      ;;            
    esac

  else 
    wifinetwork=$1
    wifipassword=$2
    if [ "$2" != "hidden" ]; then
      wifipassword=$2
    fi
    echo $1

    if [[ -n "$wifipassword" ]] && [[ "$2" != "hidden" ]]; then
      if [ ${#wifipassword} -lt 8 ]; then    
        echo "Error: password must have at least 8 characters"
        exit 1
      fi
    fi

    cp "$TEMPLATES/network/interfaces/modular" /etc/network/interfaces
    cp "$TEMPLATES/network/wlan0/default" /etc/network/interfaces.d/wlan0
    cp "$TEMPLATES/network/eth0/default" /etc/network/interfaces.d/eth0
    cp "$TEMPLATES/network/dhcpcd/modular" /etc/dhcpcd.conf
    cp "$TEMPLATES/network/dnsmasq/default" /etc/dnsmasq.conf
    cp "$TEMPLATES/rc.local/default" /etc/rc.local

    cp "$TEMPLATES/network/10-wpa_supplicant" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant
    rm -rf /etc/udev/rules.d/90-wireless.rules

    {
      echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev"
      echo "update_config=1"
      wificountry="US"
      if [ -r /etc/rpi-wifi-country ];
      then
        wificountry=$(cat /etc/rpi-wifi-country)
      fi
      echo "country=$wificountry"
   } > /etc/wpa_supplicant/wpa_supplicant.conf

   if [[ "$3" == "" ]] && [[ "$2" != "hidden" ]]; then
     if [ -z "$wifipassword" ]; 
     then
       echo "no hidden no password"     
       {
         echo "network={"
         echo "  ssid=\"$wifinetwork\""
         echo "  key_mgmt=NONE"
         echo "}"
        } >> /etc/wpa_supplicant/wpa_supplicant.conf
       restart_wifi >"$LOGFILE" 2>"$LOGFILE"
       checkwifi
       echo "connected to open wifi network"
     else
       echo "no hidden with password"	     
       wpa_passphrase "$wifinetwork" "$wifipassword" >> /etc/wpa_supplicant/wpa_supplicant.conf
       restart_wifi >"$LOGFILE" 2>"$LOGFILE"
       checkwifi
       echo "connected to password network"
     fi
  fi
     echo "wifi" > /etc/network/mode  
  if [[ "$3" == "hidden" ]] || [[ "$2" == "hidden" ]]; then 
    if [ -z "$wifipassword" ];
    then
     echo "hidden no password"	    
    {
     echo "  network={"
     echo "  ssid=\"$wifinetwork\""
     echo "  scan_ssid=1"
     echo "  key_mgmt=NONE"
     echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi
    echo  "connected to hidden open network"  
    else
     echo "echo hidden with password"	    
    {
       echo "network={"
       echo "  ssid=\"$wifinetwork\""
       echo "  key_mgmt=WPA-PSK"
       echo "  \"wifipassword\""
       echo "}"
    } >> /etc/wpa_supplicant/wpa_supplicant.conf
    restart_wifi >"$LOGFILE" 2>"$LOGFILE"
    checkwifi
    echo "connected to hidden wifi network" 
    fi
    fi

    echo "wifi" > /etc/network/mode 
  fi
  }




function wifi_help {
  echo
  echo "Usage: $BASENAME wifi <ESSID> [password]"
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
}
