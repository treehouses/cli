#!/bin/bash

function temperature () {
  #Uses `vgencmd measure_temp` command to find CPU temperature of Raspberry Pi
  reading=$(vcgencmd measure_temp)
  number0=${reading:5}
  number=${number0/%??/}
  case "$1" in
    "") echo $number"°C"
    ;;
    "celsius") echo $number0
    ;;
  esac
}

function temperature_help {
  echo ""
  echo "  Usage: $(basename "$0") temperature <celsius>"
  echo ""
  echo "  Measures CPU temperature of Raspberry Pi"
  echo ""
  echo "  Example:"
  echo "  $(basename "$0") temperature"
  echo ""
  echo "  60.43°C"
  echo ""
  echo "  $(basename "$0") temperature celsius"
  echo ""
  echo "  60.43"  
}
