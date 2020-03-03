function temperature () {
  local reading number0 number fraction resultA resultB
  #Uses `vgencmd measure_temp` command to find CPU temperature of Raspberry Pi
  reading=$(vcgencmd measure_temp)
  number0=${reading:5}
  number=${number0/%??/}
  [ "$1" = '' ] && echo "$number"
  while [ -n "$1" ];
  do
    case "$1" in
      "fahrenheit")
        fraction=$(echo "scale=1; 9.0/5.0" | bc)
        resultA=$(echo "$number*$fraction" | bc)
        resultB=$(echo "$resultA+32" | bc)
        echo $resultB"°F"
        ;;
      "celsius") 
        echo $number"°C"
        ;;
      *)
        echo -e "\n $1 is not a valid option."
        temperature_help
        break
        ;;
    esac
    shift
  done
}

function temperature_help {
  echo
  echo "  Usage: $BASENAME temperature [celsius|fahrenheit]"
  echo
  echo "  Measures CPU temperature of Raspberry Pi"
  echo
  echo "  Example:"
  echo "  $BASENAME temperature"
  echo
  echo "  47.2"
  echo 
  echo "  $BASENAME temperature celsius"
  echo
  echo "  47.2°C"
  echo
  echo "  $BASENAME temperature fahrenheit"
  echo
  echo "  117.0°F"
  echo
}
