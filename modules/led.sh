function led {
  checkrpi
  checkargn $# 2
  color="$1"
  trigger="$2"

  gLed="/sys/class/leds/led0"
  rLed="/sys/class/leds/led1"
  currentGreen=$(sed 's/.*\[\(.*\)\].*/\1/g' 2>"$LOGFILE" < "$gLed/trigger")
  currentRed=$(sed 's/.*\[\(.*\)\].*/\1/g' 2>"$LOGFILE" < "$rLed/trigger")
  green="${GREEN}green led${NC}"
  red="${RED}red led${NC}"

  case "$color" in
    green)
      led="$gLed"
      current="$currentGreen"
      ;;
    red)
      led="$rLed"
      current="$currentRed"
      ;;
    dance)
      checkroot
      echo "leds are set to dance mode."
      echo "Look at your RPi leds, green led will be in this pattern: 1 sec on; 1 off; 2 on; 1 off; 3 on; 1 off; 4 on; 1 off"
      dance > "$LOGFILE"
      ;;
    thanksgiving)
      checkroot
      echo "leds are set to thanksgiving mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Green LED: 0.5 sec off; 0.5 on"
      echo "Red LED: 0.5 off; 0.5 on; 0.25 off; 0.25 on"
      echo "Green LED: 0.5 on; 0.25 off; 0.25 on"
      echo "Red LED: 0.5 on"
      echo "Both LED: flash 2 times"
      thanksgiving > "$LOGFILE"
      ;;
    christmas)
      checkroot
      echo "leds are set to christmas mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Both LED: 1 sec on; 8 blink; 1 on"
      christmas > "$LOGFILE"
      ;;
    onam)
      checkroot
      echo "leds are set to onam mode."
      echo "Look at your Rpi leds, both leds will be in this pattern..."
      echo "Green LED: 5 blink"
      echo "Both LED: 1 sec off"
      echo "Red LED: 5 blink"
      echo "Green LED: 5 blink"
      echo "Both LED: 1 sec"
      echo "Red LED: 5 blink"
      onam > "$LOGFILE"
      ;;
    newyear)
      checkroot
      echo "leds are set to newyear mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Both LED: 1 sec off"
      echo "Green LED: 0.5 on; 0.5 off"
      echo "Red LED: 0.5 on; 0.5 off"
      echo "Both LED: flash 2 times"
      newyear > "$LOGFILE"
      ;;
    lunarnewyear)
      checkroot
      echo "leds are set to lunarnewyear mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Red LED: flashes 8 times"
      echo "Red LED: 5 off: 5 on"
      lunarnewyear > "$LOGFILE"
      ;;
    heavymetal)
      checkroot
      echo "leds are set to heavymetal mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Both LED: off; only at start"
      echo "Red LED: on 0.025 sec"
      echo "Red LED: off 0.025 sec"
      echo "Green LED: on 0.025 sec"
      echo "Green LED: off 0.025 sec"
      echo "this will happen 20 times"
      heavymetal > "$LOGFILE"
      ;;
    valentine)
      checkroot
      echo "leds are set to valentine mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Both LED: 0.25 sec off"
      echo "Green LED: 1.0 on; 0.25 off"
      echo "Red LED: 1.0 on; 0.25 off"
      echo "Both LED: flash 4 times"
      valentine > "$LOGFILE"
      ;;
    carnival)
      checkroot
      echo "leds are set to carnival mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Both LED: 2 sec on; 6 blink; 4 on"
      carnival > "$LOGFILE"
      ;;
    stpatricks)
      checkroot
      echo "leds are set to stpatricks mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Green LED: blink 2 times; on 1 sec; off 1 sec; this will happen 5 times"
      echo "Green LED: flash 20 times; on 2 sec"
      stpatricks > "$LOGFILE"
      ;;
   easter)
     checkroot
     echo "leds are set to easter mode."
     echo "Look at your RPi leds, both leds will be in this pattern..."
     echo "Both LED: off 0.5 sec"
     echo "Red LED: blink 1 time; on 0.25 sec off 2 secs"
     echo "Green LED: blink 3 times, off 1 sec on 1 sec"
     echo "Green LED: on 3 secs"
     echo "Loop next two steps 3 times:"
     echo "  Red LED: on 0.075 sec off 0.075 sec"
     echo "  Green LED: on 0.075 sec off 0.075 sec"
     easter > "$LOGFILE"
     ;;
    eid)
      checkroot

      ;;
    random)
      checkroot
      random
      return
      ;;
    "")
      if [ ! -z "$currentGreen" ]; then
        echo -e "$green: $currentGreen"
      fi
      if [ ! -z "$currentRed" ]; then
        echo -e "$red: $currentRed"
      fi
      return
      ;;
    *)
      echo -e "${RED}Error:${NC} led '$color' is not present"
      exit 1
      ;;
  esac

  if [ ! -d "$led" ]; then
    echo -e "${RED}Error:${NC} led '$color' is not present"
    exit 1
  fi

  if [ -z "$trigger" ]; then
    echo "$current"
  else
    checkroot

    if ! grep -q "$trigger" "$led/trigger" 2>"$LOGFILE"; then
      echo -e "${RED}Error:${NC} unknown led mode '$trigger'"
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

function heavymetal {
  current_red=$(led "red")
  current_green=$(led "green")

  set_brightness 0 0 && sleep 0.5    # green off
  set_brightness 1 0 && sleep 0.5    # red off

  for i in {0..19}
  do
    set_brightness 0 1 && sleep 0.025
    set_brightness 0 0 && sleep 0.025
    set_brightness 1 1 && sleep 0.025
    set_brightness 1 0 && sleep 0.025
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

function onam {
  current_red=$(led "red")
  current_green=$(led "green")

  set_brightness 0 0 && set_brightness 1 0
  counter=1
  while [ $counter -le 2 ]
  do
    set_brightness 0 0 && set_brightness 1 0
    sleep 1
    for i in {1..5}
    do
      set_brightness 0 1 && set_brightness 1 0
      sleep 0.5
      set_brightness 0 0 && set_brightness 1 0
      sleep 0.5
    done
    for i in {1..5}
    do
      set_brightness 0 0 && set_brightness 1 1
      sleep 0.5
      set_brightness 0 0 && set_brightness 1 0
      sleep 0.5
    done
    counter=$(( counter+1 ))
  done

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

function lunarnewyear {
  current_green=$(led "green")
  current_red=$(led "red")

  for i in 1 2 3 4 5 6 7 8
  do
    set_brightness 1 0 && sleep 0.1
    set_brightness 1 1 && sleep 0.1
  done

  set_brightness 1 0 && sleep 1
  set_brightness 1 1 && sleep 5

  led green "$current_green"
  led red "$current_red"
}

function valentine {
  current_red=$(led "red")
  current_green=$(led "green")

  set_brightness 0 0 && set_brightness 1 0
  sleep 0.25

  counter=0
  while [ $counter -le 4 ]
  do
    set_brightness 1 0 && set_brightness 0 1
    sleep 0.25
    set_brightness 1 1 && set_brightness 0 0
    sleep 0.25
    counter=$(( counter + 1 ))
  done

  set_brightness 1 0 && set_brightness 0 0
  sleep 0.25

  counter=0
  while [ $counter -le 4 ]
  do
    set_brightness 1 1 && set_brightness 0 1
    sleep 0.25
    set_brightness 1 0 && set_brightness 0 0
    sleep 0.25
    counter=$(( counter + 1 ))
  done

  led red "$current_red"
  led green "$current_green"
}

function carnival {
  current_red=$(led "red")
  current_green=$(led "green")

  led green none
  led red none
  sleep 2

  led red timer
  led green timer
  sleep 6

  led green none
  led red none
  sleep 4

  led red "$current_red"
  led green "$current_green"
}

function stpatricks {
  current_red=$(led "red")
  current_green=$(led "green")

  set_brightness 1 0    # red off
  set_brightness 0 0    # green off

  for i in {0..4}
  do
    set_brightness 0 1 && sleep 0.25
    set_brightness 0 0 && sleep 0.25
    set_brightness 0 1 && sleep 0.25
    set_brightness 0 0 && sleep 0.25
    set_brightness 0 1 && sleep 1
    set_brightness 0 0 && sleep 1
  done

  for i in {0..19}
  do
    set_brightness 0 1 && sleep 0.05
    set_brightness 0 0 && sleep 0.05
  done

  set_brightness 0 1 && sleep 2

  led green "$current_green"
  led red "$current_red"
}

function easter {
  current_red=$(led "red")
  current_green=$(led "green")

  set_brightness 1 0 && set_brightness 0 0 && sleep 0.5

  set_brightness 1 1 && sleep 0.25
  set_brightness 1 0 && sleep 2.0

  for i in {0..2}
  do
    set_brightness 0 0 && sleep 1.0
    set_brightness 0 1 && sleep 0.5
  done

  set_brightness 0 1 && sleep 3.0

  for i in {0..2}
  do
    set_brightness 0 1 && sleep 0.075
    set_brightness 0 0 && sleep 0.075
    set_brightness 1 1 && sleep 0.075
    set_brightness 1 0 && sleep 0.075
  done

  led red "$current_red"
  led green "$current_green"
}

function eid (

)

function random {
  rando="$(led_help | grep "led \[" \
    | cut -d "[" -f2 \
    | cut -d "]" -f1 \
    | sed -n '1!p' \
    | sed 's/|/\n/g' \
    | sed -e '/^random$/d' \
    | shuf -n 1)"
  led "$rando"
}

function led_help {
  echo
  echo "Usage: $BASENAME led [green|red] [mode]"
  echo "       $BASENAME led [dance|thanksgiving|christmas|newyear|lunarnewyear]"
  echo "                     [valentine|carnival|stpatricks|onam|heavymetal|easter|random|eid]"
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
  echo "Here is the location of LEDs"
  echo "+-------------------------------------------+"
  echo "|  ()2#################40()             +---+"
  echo "|    1#################39               |USB|"
  echo "|#D    Pi 3B/ 4B     +-+                +---+"
  echo "|#I   \/  +--+      | |                 +---+"
  echo "|#S  ()() |  | CAM  +-+                 |USB|"
  echo "|#P   ()  +--+  #                       +---+"
  echo "|#Y             #                      +----+"
  echo -e "|\e[5m\e[32m[] \e[25m\e[39m           +----+ # +-+             | NET|"
  echo -e "|\e[5m\e[31m[] \e[25m\e[39m()+---+ |      | # |A|         ()+------+"
  echo "+-------|PWR|------|HDMI|------|V|----------+"
  echo "      +-----+     +-------+           +-----+"
  echo "Example:"
  echo "  $BASENAME led"
  echo "      This will return the status of the green/red (if present) leds"
  echo
  echo "  $BASENAME led red"
  echo "      This will return the status of the red led"
  echo
  echo "  $BASENAME led green heartbeat"
  echo "      This will set the mode of the green led to heartbeat"
  echo
  echo "  $BASENAME led red default-on"
  echo "      This will set the mode of the red led to default-on"
  echo
  echo "  $BASENAME led dance"
  echo "      This will do a sequence with the green led"
  echo "      1 sec on; 1 off; 2 on; 1 off; 3 on; 1 off; 4 on; 1 off"
  echo
  echo "  $BASENAME led thanksgiving"
  echo "      This will do a sequence with the green and red led"
  echo
  echo "  $BASENAME led christmas"
  echo "      This will set the mode of the led to christmas"
  echo
  echo "  $BASENAME led newyear"
  echo "      This will set the mode of the led to newyear"
  echo
  echo "  $BASENAME led valentine"
  echo "      This will set the mode of the led to valentine"
  echo
  echo "  $BASENAME led lunarnewyear"
  echo "      This wil set the mode of the led to lunarnewyear"
  echo
  echo "  $BASENAME led carnival"
  echo "     This will set the mode of the led to carnival"
  echo
  echo "  $BASENAME led onam"
  echo "      This will set the mode of the led to onam"
  echo
  echo "  $BASENAME led heavymetal"
  echo "      This will set the mode of the led to heavymetal"
  echo
  echo "  $BASENAME led stpatricks"
  echo "     This will set the mode of the led to stpatricks"
  echo
  echo "  $BASENAME led easter"
  echo "     This will set the mode of the led to easter"
  echo
  echo " $BASENAME led eid"
  echo "     This will set the mode of the led to eid"
  echo
  echo "  $BASENAME led random"
  echo "     This will set the mode of the led to one of the above festivities"
  echo
 }
