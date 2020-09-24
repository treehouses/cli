function system {
  checkroot

  local options functions arguments errors
  options=("all" "cpu" "ram" "disk" "volt" "temperature" "cputask" "ramtask")
  functions=(system system_cpu system_ram system_disk system_volt system_temperature system_cputask system_ramtask)
  arguments=()
  errors=()

  if [ $# -eq 0 ]; then
    echo
    for (( i=1; i<${#options[*]}; i++ ))
    do
      ${functions[$i]}
    done
    echo
    exit 0
  else
    echo
    for (( i=0; i<${#options[*]}; i++ ))
    do
      for var in "$@"
      do
        if [[ ! " ${options[*]} " =~ " ${var} " ]]; then
          if [[ ! " ${errors[*]} " =~ " ${var} " ]]; then
            errors+=("$var")
          fi
          continue
        fi
        if [ "$var" == "${options[$i]}" ] && [[ ! " ${arguments[*]} " =~ " ${var} " ]]; then
          ${functions[$i]}
          arguments+=("$var")
        fi
      done
    done
    echo

    if [ ${#errors[*]} -gt 0 ]; then
      for error in ${errors[*]}
      do
        echo "Error: $error is not an option"
      done
      system_help
    fi
  fi
}

function system_cpu {
  local percentage frequency
  percentage=$(top -bn1 | grep "Cpu(s)" |\
    sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |\
    awk '{print 100 - $1"%"}')
  frequency=$(</sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq)

  echo "CPU:              $percentage @ $((frequency/1000))MHz"
}

function system_ram {
  local used total percentage
  used=$(free -m | grep Mem | awk '{print $2 - $7}')
  total=$(free -m | grep Mem | awk '{print $2}')
  percentage=$(bc -l <<< "scale=2; $used/$total" | cut -c 2-)

  echo "Memory:           $used""M/$total""M, $percentage% used"
}

function system_disk {
  local used total percentage
  used=$(df -h | grep /root | awk '{print $3}' | sed 's/G//g')
  total=$(df -h | grep /root | awk '{print $2}'| sed 's/G//g')
  percentage=$(bc -l <<< "scale=2; $used/$total" | cut -c 2-)
  
  echo "Disk storage:     $used""G/$total""G, $percentage% used"
}

function system_volt {
  echo "Volt:             $(vcgencmd measure_volts | cut -c 6-)"
}

function system_temperature {
  echo "Temperature:      $(temperature celsius) ($(temperature fahrenheit))"
}

function system_cputask {
  printf "\n\tCPU HEAVY TASKS\n"
  printf "PID\t\t\tPROCESS\n"
  cpu=$(ps -eo pid --sort=-%cpu | head -11 | sed '1d')
  for pid in $cpu
  do
    printf "%s\t\t\t%s\n" "$pid" "$(ps -p $pid -o comm=)"
  done
  echo
}

function system_ramtask {
  printf "\n\tRAM HEAVY TASKS\n"
  printf "PID\t\t\tPROCESS\n"
  ram=$(ps -eo pid --sort=-%mem | head -11 | sed '1d')
  for pid in $ram
  do
    printf "%s\t\t\t%s\n" "$pid" "$(ps -p $pid -o comm=)"
  done
  echo
}

function system_help {
  echo
  echo "Usage: $BASENAME system [all|cpu|ram|disk|volt|temperature]"
  echo
  echo "Listing real time system information corresponding to arguments"
  echo
  echo "Examples:"
  echo "  $BASENAME system"
  echo "  display all available system info"
  echo
  echo "  $BASENAME system volt"
  echo "  display the voltage of raspberry pi"
  echo
  echo "  $BASENAME system disk temperature cpu"
  echo "  display disk occupancy and temperature"
  echo
}
