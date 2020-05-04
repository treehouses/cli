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
      exit 1
      ;;
    *)
      echo "Error: power '$mode' does not exist"
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

function power_help {
  echo "Usage: $BASENAME power [mode]"
  echo "       $BASENAME power [current|freq]"
  echo
  echo "Options of modes:"
  echo "  default                     ondemand mode; moves speed from min to max at about 90% load"
  echo "  ondemand                    moves speed from min to max at about 90% load"
  echo "  conservative                Gradually switch frequencies at about 90% load"
  echo "  usespace                    Allows any program to set CPU's frequency"
  echo "  powersave                   All cores set at minimum frequency"
  echo "  performance                 All cores set at maximum frequency"
  echo
  echo "Example:"
   echo "  $BASENAME power default" 
  echo "      This will set the power mode to default (ondemand)" 
  echo "  $BASENAME power ondemand" 
  echo "      This will set the power mode to ondemand" 
  echo "  $BASENAME power conservative" 
  echo "      This will set the power mode to conservative" 
  echo "  $BASENAME power usespace" 
  echo "      This will set the power mode to userspace" 
  echo "  $BASENAME power powersave" 
  echo "      This will set the power mode to powersave" 
  echo "  $BASENAME power performance" 
  echo "      This will set the power mode to performance" 
  echo "  $BASENAME power current" 
  echo "      This will return the current power mode" 
  echo "  $BASENAME power freq" 
  echo "      This will return the current CPU frequency" 
  echo
}
