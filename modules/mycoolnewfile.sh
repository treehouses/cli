#!/bin/bash

#Adding a new feature...

function temperature () {
	#Uses `vgencmd measure_temp` command to find CPU temperature of Raspberry Pi
	reading=$(vcgencmd measure_temp) #Grab the reading for temp
	number0=${reading:5} #Remove the 'temp' from beginning
	number=${number0/%??/} #Removes the ''C' from end
	#echo "$number"°C" + 273.15" #Adds the degree celcius
	
	case "$1" in
		"") echo $number"°C" 
		;;
	"kelvin")
	echo "$number"°C" + 273.15"
	;;
	"farenheit")
	echo "($number"°C" x 9/5) + 32"
	;;
	esac
}

function temperature_help {
	echo ""
	echo " Usage: $(basename "$0") temperature [fahrenheit|kelvin]"
	echo ""
	echo " Measures CPU temperature of Raspberry Pi"
	echo ""
	echo " Example:"
	echo " $(basename "$0") temperature"
	echo ""
	echo " 60.34°C"
	echo ""
	echo " $(basename "$0") temperature fahrenheit"
	echo ""
	echo " 140.61°F"
	echo " $(basename "$0") temperature kelvin"
	echo ""
	echo " 333.49°K"
}

temperature
