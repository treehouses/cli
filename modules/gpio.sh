function gpio {
  checkargn $# 0
  pinout | sed -ne "/-------./,/----|/ p"
  echo
  model="$(treehouses detectrpi)"
  prefix="${model:0:2}"
  oldrpi="True"
  if [ ${#model} -gt 3 ]; then
    modelnum="${model:3:1}"
    if [ "$(($modelnum))" -gt 2 ] || [ "$modelnum" = "Z" ]; then
      oldrpi="False"
    fi
  fi
  if [ "$prefix" = "CM" ]; then
    pinout | sed -n "/(1)/,/(200)/ p"
  elif [ "$oldrpi" = "False" ]; then
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
    echo "   3V3  (1) (2)  5V"
    echo "  SDA0  (3) (4)  DNC"
    echo "  SCL0  (5) (6)  0V"
    echo " GPIO7  (7) (8)  TxD"
    echo "   DNC  (9) (10) RxD"
    echo " GPIO0 (11) (12) GPIO1"
    echo " GPIO2 (13) (14) DNC"
    echo " GPIO3 (15) (16) GPIO4"
    echo "   DNC (17) (18) GPIO5"
    echo "  MOSI (19) (20) DNC"
    echo "  MISO (21) (22) GPIO6"
    echo "  SCLK (23) (24) CE0"
    echo "   DNC (25) (26) CE1"
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
  echo "|  Fi  Pi Model 4B  V1.1 oo      |"
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
