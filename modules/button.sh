#!/bin/bash
# treehouses button off                        => disables button ~ it does nothing
# treehouses button bluetooth                  => bluetooth will be ON when cable is off and OFF when cable is on

function button {
  mode=$1

  if [ "$mode" = "off" ]; then
    disable_service gpio-button
    stop_service gpio-button
    rm -rf  /etc/systemd/system/gpio-button.service
    rm -rf /etc/gpio-button-action-on.sh /etc/gpio-button-action-off.sh

    echo "ok. button disabled"
  elif [ "$mode" = "bluetooth" ]; then
    {
      echo '#!/bin/bash'
      echo "treehouses bluetooth pause"
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
  else
    echo "Unknown option."
  fi
}


function button_help () {
  echo
  echo "Usage: treehouses button <off|bluetooth>"
  echo
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
  echo
  echo
  echo "Examples:"
  echo "  treehouses button off"
  echo "      Disables the action that is run when the GPIO pin 18 is on"
  echo
  echo "  treehouses button bluetooth"
  echo "      When the GPIO pin 18 is on the bluetooth will be turned off".
  echo "      Otherwise the bluetooth mode will be changed to hotspot."
  echo
}
