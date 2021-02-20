function temperature () {
  local reading number0 number fraction resultA resultB
  checkrpi
  checkargn $# 1
  check_missing_packages "bc"
  #Uses `vgencmd measure_temp` command to find CPU temperature of Raspberry Pi
  reading=$(vcgencmd measure_temp)
  number0=${reading:5}
  number=${number0/%??/}
  case "$1" in
    "")
      echo $number
      ;;
    "celsius")
      echo $number"°C"
      ;;
    "fahrenheit")
      fraction=$(echo "scale=1; 9.0/5.0" | bc)
      resultA=$(echo "$number*$fraction" | bc)
      resultB=$(echo "$resultA+32" | bc)
      echo $resultB"°F"
      ;;
    "kelvin")
      result=$(echo "$number+273.15" | bc)
      echo $result"K"
      ;;
    *)
      log_help_and_exit1 "Error: not a valid option" temperature
      ;;
  esac
}

function temperature_help {
  echo
  echo "Usage: $BASENAME temperature [celsius|fahrenheit|kelvin]"
  echo
  echo "Measures CPU temperature of Raspberry Pi"
  echo
  echo "Example:"
  echo "  $BASENAME temperature"
  echo "  47.2"
  echo
  echo "  $BASENAME temperature celsius"
  echo "  47.2°C"
  echo
  echo "  $BASENAME temperature fahrenheit"
  echo "  117.0°F"
  echo
  echo "  $BASENAME temperature kelvin"
  echo "  320.35K"
  echo
}
