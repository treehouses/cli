function gpio {
  checkargn $# 0
  checkrpi
  model="$(detectrpi)"
  prefix="${model:0:2}"
  oldrpi="True"
  if [ ${#model} -gt 3 ]; then
    modelnum="${model:3:1}"
    if [ "${model:3:2}" = "ZW" ] || [ $modelnum -gt 2 ]; then
      oldrpi="False"
    fi
  fi
  if [ "$oldrpi" = "False" ]; then
    if [ "$modelnum" = "Z" ]; then
      echo ".-------------------------."
      echo "| oooooooooooooooooooo J8 |"
      echo "| 1ooooooooooooooooooo   |c"
      echo "---+       +---+ PiZero W|s"
      echo "sd|       |SoC|         |i"
      echo "---+|hdmi| +---+  usb pwr |"
      echo "\`---|    |--------| |-| |-'"
    elif [ "$modelnum" = "4" ]; then
      echo ",--------------------------------."
      echo "| oooooooooooooooooooo J8   +======"
      echo "| 1ooooooooooooooooooo  PoE |   Net"
      echo "|  Wi                    oo +======"
      echo "|  Fi  Pi Model 4B       oo      |"
      echo "|        ,----.               +===="
      echo "| |D|    |SoC |               |USB3"
      echo "| |S|    |    |               +====" 
      echo "| |I|    '----'                  |"
      echo "|                   |C|       +===="
      echo "|                   |S|       |USB2"
      echo "| pwr   |HD|   |HD| |I||A|    +===="
      echo "\`-| |---|MI|---|MI|----|V|-------'"
    else 
      if [ ${#model} -gt 4 ]; then
        echo ",--------------------------------."
        echo "| oooooooooooooooooooo J8     +===="
        echo "| 1ooooooooooooooooooo        | USB"
        echo "|                             +===="
        echo "|      Pi Model 3B+              |"
        echo "|      +----+                 +===="
        echo "| |D|  |SoC |                 | USB"
        echo "| |S|  |    |                 +===="
        echo "| |I|  +----+                    |"
        echo "|                    |C|     +======"
        echo "|                    |S|     |   Net"
        echo "| pwr         |HDMI| |I||A|  +======"
        echo "\`-| |--------|    |----|V|-------'"
      else
        echo ",--------------------------------."
        echo "| oooooooooooooooooooo J8     +===="
        echo "| 1ooooooooooooooooooo        | USB"
        echo "|                             +===="
        echo "|      Pi Model 3B               |"
        echo "|      +----+                 +===="
        echo "| |D|  |SoC |                 | USB"
        echo "| |S|  |    |                 +===="
        echo "| |I|  +----+                    |"
        echo "|                   |C|     +======"
        echo "|                   |S|     |   Net"
        echo "| pwr        |HDMI| |I||A|  +======"
        echo "\`-| |--------|    |----|V|-------'"
      fi 
    fi
    echo
    echo "   3V3  (1) (2)  5V"
    echo " GPIO2  (3) (4)  5V"  
    echo " GPIO3  (5) (6)  GND"
    echo " GPIO4  (7) (8)  GPIO14"
    echo "   GND  (9) (10) GPIO15"
    echo "GPIO17 (11) (12) GPIO18"
    echo "GPIO27 (13) (14) GND"
    echo "GPIO22 (15) (16) GPIO23"
    echo "   3V3 (17) (18) GPIO24"
    echo "GPIO10 (19) (20) GND"
    echo " GPIO9 (21) (22) GPIO25"
    echo "GPIO11 (23) (24) GPIO8"
    echo "   GND (25) (26) GPIO7"
    echo " GPIO0 (27) (28) GPIO1"
    echo " GPIO5 (29) (30) GND"
    echo " GPIO6 (31) (32) GPIO12"
    echo "GPIO13 (33) (34) GND"
    echo "GPIO19 (35) (36) GPIO16"
    echo "GPIO26 (37) (38) GPIO20"
    echo "   GND (39) (40) GPIO21"
  else
    checkinternet
    pinout
  fi
  echo
}

function gpio_help {
  echo
  echo "Usage: $BASENAME gpio"
  echo
  echo "Displays picture model of raspberry pi and corresponding GPIO ports"
  echo
  echo "Example:"
  echo "  $BASENAME gpio"
  echo ",--------------------------------."
  echo "| oooooooooooooooooooo J8   +======"
  echo "| 1ooooooooooooooooooo  PoE |   Net"
  echo "|  Wi                    oo +======"
  echo "|  Fi  Pi Model 4B       oo      |"
  echo "|        ,----.               +===="
  echo "| |D|    |SoC |               |USB3"
  echo "| |S|    |    |               +====" 
  echo "| |I|    '----'                  |"
  echo "|                   |C|       +===="
  echo "|                   |S|       |USB2"
  echo "| pwr   |HD|   |HD| |I||A|    +===="
  echo "'-| |---|MI|---|MI|----|V|-------'"
  echo 
  echo "   3V3  (1) (2)  5V"
  echo " GPIO2  (3) (4)  5V"  
  echo " GPIO3  (5) (6)  GND"
  echo " GPIO4  (7) (8)  GPIO14"
  echo "   GND  (9) (10) GPIO15"
  echo "GPIO17 (11) (12) GPIO18"
  echo "GPIO27 (13) (14) GND"
  echo "GPIO22 (15) (16) GPIO23"
  echo "   3V3 (17) (18) GPIO24"
  echo "GPIO10 (19) (20) GND"
  echo " GPIO9 (21) (22) GPIO25"
  echo "GPIO11 (23) (24) GPIO8"
  echo "   GND (25) (26) GPIO7"
  echo " GPIO0 (27) (28) GPIO1"
  echo " GPIO5 (29) (30) GND"
  echo " GPIO6 (31) (32) GPIO12"
  echo "GPIO13 (33) (34) GND"
  echo "GPIO19 (35) (36) GPIO16"
  echo "GPIO26 (37) (38) GPIO20"
  echo "   GND (39) (40) GPIO21"
  echo
}
