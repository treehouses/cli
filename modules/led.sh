#!/bin/bash

function led {
  color="$1"
  trigger="$2"

  gLed="/sys/class/leds/led0"
  rLed="/sys/class/leds/led1"
  currentGreen=$(sed 's/.*\[\(.*\)\].*/\1/g' 2>/dev/null < "$gLed/trigger")
  currentRed=$(sed 's/.*\[\(.*\)\].*/\1/g' 2>/dev/null < "$rLed/trigger")
  green="${GREEN}green led${NC}"
  red="${RED}red led${NC}"

  if [ "$color" = "green" ]; then
    led="$gLed"
    current="$currentGreen"
  elif [ "$color" = "red" ]; then
    led="$rLed"
    current="$currentRed"
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

    if [ "$color" = "green" ]; then
      echo -e "$green: $newValue"
    elif [ "$color" = "red" ]; then
      echo -e "$red: $newValue"
    fi
  fi
}

function led_help {
  echo ""
  echo "Usage: $(basename "$0") led [green|red] [mode]"
  echo ""
  echo "Sets or returns the led mode"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") led"
  echo "      This will return the status of the green/red (if present) leds"
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
}