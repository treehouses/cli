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
	# delete after debugging
	debug
	> storeGreen.txt
	> storeRed.txt
	echo $currentGreen > storeGreen.txt
	echo $currentRed > storeRed.txt
	current="$currentGreen"
	current="$currentRed"
	debug

  case "$color" in
    green)
      led="$gLed"
      current="$currentGreen"
      ;;
    red)
      led="$rLed"
      current="$currentRed"
      ;;
    newyear)
	# delete after debugging
	debug
      checkroot
      echo "leds are set to newyear mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Both LED: 1 sec off"
      echo "Green LED: 0.5 on; 0.5 off"
      echo "Red LED: 0.5 on; 0.5 off"
      echo "Both LED: flash 2 times"
      newyear > "$LOGFILE"
	# delete after debugging
	debug
      ;;
    esac

# delete after debugging
	debug
	currentGreen=$(cat storeGreen.txt)
	currentRed=$(cat storeRed.txt)
	debug

#  if [ ! -d "$led" ]; then
#    echo -e "${RED}Error:${NC} led '$color' is not present"
#    exit 1
#  fi

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

    if [ ! -z "$currentGreen" ]; then
      echo -e "$green: $currentGreen"
    fi
    if [ ! -z "$currentRed" ]; then
      echo -e "$red: $currentRed"
    fi
  fi

	#delete after debugging
	#function led green $(cat storeGreen.txt)
	#function led red $(cat storeRed.txt)

}

function set_brightness {
  echo "$2" > "/sys/class/leds/led$1/brightness"
}

function newyear {
#  current_green=$(led "green")
#  current_red=$(led "red")

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

#  led green "$current_green"
#  led green "$currentGreen"
#  led red "$current_red"
#  led red "$currentRed"
}

function led_help {
  echo
  echo "Usage: $BASENAME led [green|red] [mode]"
  echo "       $BASENAME led [newyear|blackhistorymonth|lunarnewyear|valentine|carnival|lantern|stpatricks]"
  echo "                      [easter|labourday|eid|dragonboat|independenceday|onam|diwali|thanksgiving]"
  echo "                      [christmas|dance|heavymetal|sandstorm|random]"
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
  echo "  $BASENAME led newyear"
  echo "      This will set the mode of the led to newyear"
  echo
  echo "  $BASENAME led blackhistorymonth"
  echo "      This will set the mode of the led to blackhistorymonth"
  echo
  echo "  $BASENAME led lunarnewyear"
  echo "      This will set the mode of the led to lunarnewyear"
  echo
  echo "  $BASENAME led valentine"
  echo "      This will set the mode of the led to valentine"
  echo
  echo "  $BASENAME led carnival"
  echo "     This will set the mode of the led to carnival"
  echo
  echo "  $BASENAME led lantern"
  echo "     This will set the mode of the led to lantern"
  echo
  echo "  $BASENAME led stpatricks"
  echo "     This will set the mode of the led to stpatricks"
  echo
  echo "  $BASENAME led easter"
  echo "     This will set the mode of the led to easter"
  echo
  echo "  $BASENAME led labourday"
  echo "      This will set the mode of the led to labourday"
  echo
  echo "  $BASENAME led eid"
  echo "     This will set the mode of the led to eid"
  echo
  echo "  $BASENAME led dragonboat"
  echo "      This will set the mode of the led to dragonboat"
  echo
  echo "  $BASENAME led independenceday"
  echo "      This will set the mode of the led to independenceday"
  echo
  echo "  $BASENAME led onam"
  echo "      This will set the mode of the led to onam"
  echo
  echo "  $BASENAME led diwali"
  echo "      This will set the mode of the led to diwali"
  echo
  echo "  $BASENAME led thanksgiving"
  echo "      This will do a sequence with the green and red led"
  echo
  echo "  $BASENAME led christmas"
  echo "      This will set the mode of the led to christmas"
  echo
  echo "  $BASENAME led dance"
  echo "      This will do a sequence with the green led"
  echo
  echo "  $BASENAME led heavymetal"
  echo "      This will set the mode of the led to heavymetal"
  echo
  echo "  $BASENAME led kecak"
  echo "      This will set the mode of the led to kecak"
  echo
  echo "  $BASENAME led sandstorm"
  echo "      This will set the mode of the led to sandstorm"
  echo
  echo "  $BASENAME led random"
  echo "     This will set the mode of the led to one of the above festivities"
  echo
}

# delete after debugging
function debug {
      echo -e "  TEST $green: $currentGreen"
      echo -e "  TEST $red: $currentRed"
      echo "storeGreen:"
      cat storeGreen.txt
      echo "storeRed:"
      cat storeRed.txt
      echo "    END DEBUG"
}
