function power {
  checkrpi
  checkargn $# 1
  mode="$1"
  case "$mode" in
    # threshold)
    #   checkroot
    #   echo "changing threshold"
    #     changethreshhold
    #     ;;
    # cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
    current)
      checkroot
      echo "Power mode is currently $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
      ;;
    status)
      checkroot
      checkstatus
      ;;
    default | ondemand)
      checkroot
      echo "Moves speed from min to max at about 90% load"
      changegovernor "ondemand"
      ;;
    conservative)
      checkroot 
      echo "Gradually switch frequencies at about 90% load"
      changegovernor "conservative"
      ;;
    userspace)
      checkroot
      echo "Allows any program to set CPU's frequency"
      changegovernor "userspace"
      ;;
    powersave)
      checkroot
      echo "All cores set at minimum frequency"
      changegovernor "powersave"
      ;;
    performance)
      checkroot
      echo "All cores set at maximum frequency"
      changegovernor "performance"
      ;; 
    freq)
      checkroot
      echo "CPU frequency is now $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)"
      ;;
    "")
      echo "Error: please choose one of the 5 modes"
      power_help
      exit 1
      ;;
    *)
      echo "Error: power '$mode' does not exist"
      power_help
      exit 1
      ;;
  esac     
}

function changegovernor {
  sudo echo $1 | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null 2>&1
  RESULT=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
  if [ "$RESULT" == "$1" ]; then
    echo "Scaling governor set to $RESULT"
  else
    echo "Failure, may need to use sudo"
  fi
}

function checkstatus {
  # Bit representation
  UNDERVOLTED=0x1
  CAPPED=0x2
  THROTTLED=0x4
  HAS_UNDERVOLTED=0x10000
  HAS_CAPPED=0x20000
  HAS_THROTTLED=0x40000

  #Text Colors
  GREEN=$(tput setaf 2)
  RED=$(tput setaf 1)
  NC=$(tput sgr0)

  #Output Strings
  GOOD="${GREEN}NO${NC}"
  BAD="${RED}YES${NC}"

  #Get Status, extract hex values
  STATUS=$(vcgencmd get_throttled)
  STATUS=${STATUS#*=}

  echo -n "Status: "
  ((STATUS!=0)) && echo "${RED}${STATUS}${NC}" || echo "${GREEN}${STATUS}${NC}"

  echo "Undervolted:"
  echo -n "   Now: "
  (((STATUS&UNDERVOLTED)!=0)) && echo "${BAD}" || echo "${GOOD}"
  echo -n "   Has Occurred Since Last Reboot: "
  (((STATUS&HAS_UNDERVOLTED)!=0)) && echo "${BAD}" || echo "${GOOD}"

  echo "Throttled:"
  echo -n "   Now: "
  (((STATUS&THROTTLED)!=0)) && echo "${BAD}" || echo "${GOOD}"
  echo -n "   Has Occurred Since Last Reboot: "
  (((STATUS&HAS_THROTTLED)!=0)) && echo "${BAD}" || echo "${GOOD}"

  echo "Frequency Capped:"
  echo -n "   Now: "
  (((STATUS&CAPPED)!=0)) && echo "${BAD}" || echo "${GOOD}"
  echo -n "   Has Occurred Since Last Reboot: "
  (((STATUS&HAS_CAPPED)!=0)) && echo "${BAD}" || echo "${GOOD}"
  vcgencmd get_throttled
}
function power_help {
  echo "Usage: $BASENAME power [mode]"
  echo "       $BASENAME power [current|freq|status]"
  echo "Options of modes:"
  echo "  default                     ondemand mode; moves speed from min to max at about 90% load"
  echo "  ondemand                    moves speed from min to max at about 90% load"
  echo "  conservative                gradually switch frequencies at about 90% load"
  echo "  userspace                    allows any program to set CPU's frequency"
  echo "  powersave                   all cores set at minimum frequency"
  echo "  performance                 all cores set at maximum frequency"
  echo
  echo "Example:"
  echo "  $BASENAME power status"
  echo "      This returns the status of the power"
  echo
  echo "  $BASENAME power default" 
  echo "      This will set the power mode to default (ondemand)" 
  echo
  echo "  $BASENAME power ondemand" 
  echo "      This will set the power mode to ondemand" 
  echo
  echo "  $BASENAME power conservative" 
  echo "      This will set the power mode to conservative" 
  echo
  echo "  $BASENAME power userspace" 
  echo "      This will set the power mode to userspace" 
  echo
  echo "  $BASENAME power powersave" 
  echo "      This will set the power mode to powersave" 
  echo
  echo "  $BASENAME power performance" 
  echo "      This will set the power mode to performance" 
  echo
  echo "  $BASENAME power current" 
  echo "      This will return the current power mode" 
  echo
  echo "  $BASENAME power freq" 
  echo "      This will return the current CPU frequency" 
  echo
}
