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
  elif [ "$color" = "both" ]; then
    led green $trigger
    led red $trigger
    exit 0
  elif [ "$color" = "dance" ]; then
    checkroot
    echo "leds are set to dance mode."
    echo "The pattern of leds will be 1 sec on; 1 off; 2 on; 1 off; 3 on; 1 off; 4 on; 1 off"
    echo "Look at the you leds' RPi"
    echo "+-------------------------------------------+"
    echo "|  ()2#################40()             +---+"
    echo "|    1#################39               |USB|"
    echo "|#D    Pi B+ / Pi 2 +-+                 +---+"
    echo "|#I   \/  +--+      | |                 +---+"
    echo "|#S  ()() |  | CAM  +-+                 |USB|"
    echo "|#P   ()  +--+  #                       +---+"  
    echo "|#Y             #                      +----+"
    echo "|Green LED-->[]        +----+ # +-+    | NET|"
    echo "|Red LED-->[]()+---+ |    | # |A|  ()+------+"
    echo "+-------|PWR|------|HDMI|------|V|----------+"
    echo "      +-----+     +-------+           +-----+"
    dance > /dev/null
  elif [ "$color" = "thanksgiving" ]; then
    checkroot
    echo "leds are set to thanksgiving mode."
    thanksgiving > /dev/null
  elif [ "$color" = "christmas" ]; then
    checkroot
    echo "leds are set to christmas mode."
    christmas > /dev/null
  elif [ "$color" = "newyear" ]; then
    checkroot
    echo "leds are set to newyear mode."
    newyear > /dev/null
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
    if [ $led = $gLed ]; then
      echo -e "$green: $currentGreen"
    elif [ $led = $rLed ]; then
      echo -e "$red: $currentRed"
    fi
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

function thanksgiving {
  current_red=$(led "red")
  current_green=$(led "green")

  for i in {0..1}
  do
    set_brightness 0 0 && sleep 0.5    # green off
    set_brightness 0 1 && sleep 0.5    # green on
  done

  for i in {0..1}
  do
    set_brightness 1 0 && sleep 0.5    # red off
    set_brightness 1 1 && sleep 0.5    # red on
  done

  set_brightness 0 0
  for i in {0..1}
  do
    set_brightness 1 0 && sleep 0.25
    set_brightness 1 1 && sleep 0.25
  done
  set_brightness 0 1 && sleep 0.5

  set_brightness 1 0
  for i in {0..1}
  do 
    set_brightness 0 0 && sleep 0.25
    set_brightness 0 1 && sleep 0.25
  done
  set_brightness 1 1 && sleep 0.5

  for i in {0..3}
  do
    set_brightness 1 0
    set_brightness 0 0 && sleep 0.25
    set_brightness 1 1
    set_brightness 0 1 && sleep 0.25
  done

  led red "$current_red"
  led green "$current_green"
}

function christmas {
  current_red=$(led "red")
  current_green=$(led "green")

  led green none
  led red none
  sleep 1
  
  led red timer
  led green timer
  sleep 8

  led green none
  led red none
  sleep 1

  led red "$current_red"
  led green "$current_green"
}

function newyear {
  current_green=$(led "green")
  current_red=$(led "red")

  set_brightness 0 0 && set_brightness 1 0
  sleep 1

  counter=0
  while [ $counter -le 2 ]
  do
    set_brightness 1 0 && set_brightness 0 1
    sleep 0.5
    set_brightness 1 1 && set_brightness 0 0
    sleep 0.5
    counter=$(( counter + 1 ))
  done

  set_brightness 1 0 && set_brightness 0 0
  sleep 0.5

  counter=0
  while [ $counter -le 2 ]
  do
    set_brightness 1 1 && set_brightness 0 1
    sleep 0.5
    set_brightness 1 0 && set_brightness 0 0
    sleep 0.5
    counter=$(( counter + 1 ))
  done

  led green "$current_green"
  led red "$current_red"
}

function led_help {
  echo
  echo "Usage: $(basename "$0") led [green|red|both] [mode]"
  echo "       $(basename "$0") led [dance|thanksgiving|christmas|newyear]"
  echo
  echo "Sets or returns the led mode"
  echo
  echo "This will help a user to identify a raspberry pi (if a user is working on many of raspberry pis)"
  echo
  echo " Where to find all modes: cat /sys/class/leds/led0/trigger"
  echo
  echo " OPTIONS OF MODES: "
  echo "  default-on                 turns LED on"
  echo "  oneshot                    turns LED on once"
  echo "  heartbeat                  sets LED to heartbeat pattern"
  echo "  timer                      sets LED to flash at a 1-second interval"
  echo "  cpu0                       sets LED to CPU activity"
  echo "  gpio                       controlled through GPIO "
  echo "  input                      under-voltage detection"
  echo "  backlight                  turns off LED"
  echo "  none                       sets LED to none"
  echo "  kbd-[numlock|capslock|etc] sets LED when keyboard key is hit"
  echo
  echo "Example:"
  echo "  $(basename "$0") led"
  echo "      This will return the status of the green/red (if present) leds"
  echo
  echo "  $(basename "$0") led both"
  echo "      This will return the status of both green/red (if present) leds"
  echo
  echo "  $(basename "$0") led red"
  echo "      This will return the status of the red led"
  echo
  echo "  $(basename "$0") led green heartbeat"
  echo "      This will set the mode of the green led to heartbeat"
  echo
  echo "  $(basename "$0") led red default-on"
  echo "      This will set the mode of the red led to default-on"
  echo
  echo "  $(basename "$0") led both none"
  echo "      This will set the mode of the both leds to none"
  echo
  echo "  $(basename "$0") led dance"
  echo "      This will do a sequence with the green led"
  echo "      1 sec on; 1 off; 2 on; 1 off; 3 on; 1 off; 4 on; 1 off"
  echo 
  echo "  $(basename "$0") led thanksgiving"
  echo "      This will do a sequence with the green and red led"
  echo
  echo "  $(basename "$0") led christmas"
  echo "      This will set the mode of the led to christmas"
  echo 
}
