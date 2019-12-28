#!/bin/bash

function temperature () {
  #Uses `vgencmd measure_temp` command to find CPU temperature of Raspberry Pi
  reading=$(vcgencmd measure_temp)
  number0=${reading:5}
  number=${number0/%??/}
  case "$1" in
    "")	
      echo $number	
      ;;	  
    "fahrenheit")
      fraction=$(echo "scale=2; 9.0/5.0" | bc)
      resultA=$(echo "$number*$fraction" | bc)
      resultB=$(echo "$resultA+32" | bc)
      echo $resultB"°F"
      ;;
    "celsius") 
      echo $number"°C"
      ;;
  esac
}

function temperature_help {
  echo ""
  echo "  Usage: $(basename "$0") temperature <celsius|fahrenheit>"
  echo ""
  echo "  Measures CPU temperature of Raspberry Pi"
  echo ""
  echo "  Example:"
  echo "  $(basename "$0") temperature celsius"
  echo ""
  echo "  47.2°C"
  echo ""
  echo "  $(basename "$0") temperature fahrenheit"
  echo ""
  echo "  116.96°F"  
}
