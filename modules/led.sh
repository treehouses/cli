#!/bin/bash

function led {
  color="$1"
  trigger="$2"

  gLed="/sys/class/leds/led0"
  rLed="/sys/class/leds/led1"
  bLed=( "${gLed}" "${rLed}")
  currentGreen=$(sed 's/.*\[\(.*\)\].*/\1/g' 2>/dev/null < "$gLed/trigger")
  currentRed=$(sed 's/.*\[\(.*\)\].*/\1/g' 2>/dev/null < "$rLed/trigger")
  bothcurrent="${currentGreen} ${currentRed}"
  green="${GREEN}green led${NC}"
  red="${RED}red led${NC}"

  if [ "$color" = "green" ]; then
    led="$gLed"
    current="$currentGreen"
  elif [ "$color" = "red" ]; then
    led="$rLed"
    current="$currentRed"
  elif [ "$color" = "both" ]; then
    led="$bLed"
    current="$bothcurrent"
  elif [ "$color" = "dance" ]; then
    checkroot
    dance > /dev/null
  else
    if [ -z "$color" ]; then
      if [ ! -z "$currentGreen" ]; then
        echo -e "$green: $currentGreen"
      fi

      if [ ! -z "$currentRed" ]; then
        echo -e "$red: $currentRed"
      fi

      exit 0
    else
      echo -e "${RED}Error:${NC} led '$color' is not present"
      exit 1
    fi
  fi

  if [ ! -d "$led" ]; then
    echo -e "${RED}Error:${NC} led '$color' is not present"
    exit 1
  fi

  if [ -z "$trigger" ]; then
    echo "$current"
  else
    checkroot

    if ! grep -q "$trigger" "$led/trigger" 2>/dev/null; then
        echo -e "${RED}Error:${NC} unkown led mode '$trigger'"
        exit 1
    fi

    echo "$trigger" > "$led/trigger"
    newValue=$(sed 's/.*\[\(.*\)\].*/\1/g' < "$led/trigger")
    set_brightness "${led: -1}" 1

    if [ "$color" = "green" ]; then
      echo -e "$green: $newValue"
    elif [ "$color" = "red" ]; then
      echo -e "$red: $newValue"
    fi
  fi
}

function set_brightness {
  echo "$2" > "/sys/class/leds/led$1/brightness"
}

function dance {
  current_green=$(led "green")
  current_red=$(led "red")

  led red none
  set_brightness 1 0

  led green none
  set_brightness 0 0

  set_brightness 0 1 && sleep 1
  set_brightness 0 0 && sleep 1
  set_brightness 0 1 && sleep 2
  set_brightness 0 0 && sleep 1
  set_brightness 0 1 && sleep 3
  set_brightness 0 0 && sleep 1
  set_brightness 0 1 && sleep 4
  set_brightness 0 0 && sleep 1

  led red "$current_red"
  led green "$current_green"
}

function led_help {
  echo ""
  echo "Usage: $(basename "$0") led [green|red|both|dance] [mode]"
  echo ""
  echo "Sets or returns the led mode"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") led"
  echo "      This will return the status of the green/red (if present) leds"
  echo ""
  echo "  $(basename "$0") led both"
  echo "      This will return the status of both green/red (if present) leds"
  echo ""
  echo "  $(basename "$0") led red"
  echo "      This will return the status of the green led"
  echo ""
  echo "  $(basename "$0") led red heartbeat"
  echo "      This will set the mode of the red led to heartbeat"
  echo ""
  echo "  $(basename "$0") led green heartbeat"
  echo "      This will set the mode of the green led to heartbeat"
  echo ""
  echo "  $(basename "$0") led both none"
  echo "      This will set the mode of the both leds to none"
  echo ""
  echo "  $(basename "$0") led dance"
  echo "      This will do a sequence with the green led"
  echo "      1 sec on; 1 off; 2 on; 1 off; 3 on; 1 off; 4 on; 1 off"
  echo ""
}
