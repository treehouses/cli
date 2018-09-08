#!/bin/bash
# treehouses button off                        => disables button ~ it does nothing
# treehouses button bluetooth                  => bluetooth will be ON when cable is off and OFF when cable is on
# treehouses button wifi <essid> [password]    => rpi will disconnect from wifi and disconnect when cable is off

function button {
  mode=$1
  extra1=$2
  extra2=$3

  if [ "$mode" = "off" ]; then
    disable_service gpio-button
    stop_service gpio-button
    rm -rf  /etc/systemd/system/gpio-button.service
    rm -rf /etc/gpio-button-action-on.sh /etc/gpio-button-action-off.sh

    echo "ok. button disabled"
  elif [ "$mode" = "bluetooth" ]; then
    {
      echo '#!/bin/bash'
      echo "treehouses bluetooth off no"
    } > /etc/gpio-button-action-on.sh

    {
      echo '#!/bin/bash'
      echo "treehouses bluetooth on"
    } > /etc/gpio-button-action-off.sh

    cp "$TEMPLATES/gpio-button.service" /etc/systemd/system/
    sed -i "s|TEMPLATES|${TEMPLATES}|g" /etc/systemd/system/gpio-button.service
    systemctl daemon-reload
    enable_service gpio-button
    restart_service gpio-button

    echo "ok. button enabled"
  elif [ "$mode" = "wifi" ]; then
    if [ -n "$extra2" ]; then
      if [ ${#extra2} -lt 8 ]
      then
        echo "Error: password must have at least 8 characters"
        exit 1
      fi
    fi

    if [ -z "$extra1" ]; then
      echo "Error: essid can't be empty"
      exit 1
    fi

    {
      echo '#!/bin/bash'
      echo "treehouses wifi \"$extra1\" \"$extra2\""
    } > /etc/gpio-button-action-on.sh

    {
      echo '#!/bin/bash'
      echo "source \"$TEMPLATES\"/../modules/globals.sh"
      echo "cp \"$TEMPLATES/network/interfaces/default\" /etc/network/interfaces"
      echo "cp \"$TEMPLATES/network/dhcpcd/default\" /etc/dhcpcd.conf"
      echo "cp \"$TEMPLATES/network/dnsmasq/default\" /etc/dnsmasq.conf"
      echo "cp \"$TEMPLATES/rc.local/default\" /etc/rc.local"
      echo "cp \"$TEMPLATES/network/10-wpa_supplicant\" /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant"
      echo "rm -rf /etc/udev/rules.d/90-wireless.rules"
      echo "cp \"$TEMPLATES/network/wpa_supplicant\" \"/etc/wpa_supplicant/wpa_supplicant.conf\""
      echo "restart_wifi"
    } > /etc/gpio-button-action-off.sh

    cp "$TEMPLATES/gpio-button.service" /etc/systemd/system/
    sed -i "s|TEMPLATES|${TEMPLATES}|g" /etc/systemd/system/gpio-button.service
    systemctl daemon-reload
    enable_service gpio-button
    restart_service gpio-button

    echo "ok. button enabled"
  else
    echo "Unknown option."
  fi
}


function button_help () {
  echo ""
  echo "Usage: treehouses button <off|bluetooth|wifi> [ESSID] [password]"
  echo ""
  echo "Gives the gpio pin 18 an action."
  echo "              Pin 1 Pin2"
  echo "           +3V3 [ ] [ ] +5V"
  echo " SDA1 / GPIO  2 [ ] [ ] +5V"
  echo " SCL1 / GPIO  3 [ ] [ ] GND"
  echo "        GPIO  4 [ ] [ ] GPIO 14 / TXD0"
  echo "            GND [ ] [ ] GPIO 15 / RXD0"
  echo "        GPIO 17 [ ] [ ] GPIO 18"
  echo "        GPIO 27 [ ] [ ] GND"
  echo "        GPIO 22 [ ] [ ] GPIO 23"
  echo "           +3V3 [X] [X] GPIO 24"
  echo " MOSI / GPIO 10 [ ] [ ] GND"
  echo " MISO / GPIO  9 [ ] [ ] GPIO 25"
  echo " SCLK / GPIO 11 [ ] [ ] GPIO  8 / CE0#"
  echo "            GND [ ] [ ] GPIO  7 / CE1#"
  echo "ID_SD / GPIO  0 [ ] [ ] GPIO  1 / ID_SC"
  echo "        GPIO  5 [ ] [ ] GND"
  echo "        GPIO  6 [ ] [ ] GPIO 12"
  echo "        GPIO 13 [ ] [ ] GND"
  echo " MISO / GPIO 19 [ ] [ ] GPIO 16 / CE2#"
  echo "        GPIO 26 [ ] [ ] GPIO 20 / MOSI"
  echo "            GND [ ] [ ] GPIO 21 / SCLK"
  echo "             Pin 39 Pin 40"
  echo ""
  echo ""
  echo "Examples:"
  echo "  treehouses button off"
  echo "      Disables the action that is run when the GPIO pin 18 is on"
  echo ""
  echo "  treehouses button bluetooth"
  echo "      When the GPIO pin 18 is on the bluetooth will be turned off".
  echo "      Otherwise the bluetooth mode will be changed to hotspot."
  echo ""
  echo "  treehouses button wifi <ESSID> [Password]"
  echo "      When the GPIO pin 18 is on the wifi will be turned off".
  echo "      Otherwise the raspberry pi will connect to the specified network."
  echo ""
}
