function ledtest () {
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
    newyear)
  		current_green=$(led "green")
	      current_red=$(led "red")
	    debug
      checkroot
      echo "leds are set to newyear mode."
      echo "Look at your RPi leds, both leds will be in this pattern..."
      echo "Both LED: 1 sec off"
      echo "Green LED: 0.5 on; 0.5 off"
      echo "Red LED: 0.5 on; 0.5 off"
      echo "Both LED: flash 2 times"
      newyear > "$LOGFILE"
	    debug
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

    if [ ! -z "$currentGreen" ]; then
      echo -e "$green: $newValue"
    fi
    if [ ! -z "$currentRed" ]; then
      echo -e "$red: $newValue"
	    debug
    fi
  fi
}

function set_brightness {
  echo "$2" > "/sys/class/leds/led$1/brightness"
}

function newyear {
	echo "  START function"

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

  	debug
  led green "$current_green"
  	debug
  led red "$current_red"
  	debug
	echo "  END function"
}

function debug {
  current_green=$(led "green")
  current_red=$(led "red")
      echo -e "  TEST $green: $currentGreen"
      echo -e "  TEST $red: $currentRed"
    }
