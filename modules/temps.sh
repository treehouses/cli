#!/bin/bash
#Adding a new feature...

function temps () {
	#Uses `vgencmd measure_temp` command to find CPU temperature of Raspberry Pi
	reading=$(vcgencmd measure_temp) #Grab the reading for temp
	number0=${reading:5} #Remove the 'temp' from beginning
	number=${number0/%????/} #Removes the '.00'C' from end
	#echo "$number"°C" + 273.15" #Adds the degree celcius
	
	case "$1" in
		"") 
            echo "${number}°C";;
	    "kelvin")
	        echo "$((number+273))°K";;
	    "fahrenheit")
	        echo "$((number * 2 + 32))°F";;
	esac
}

function temps_help {
	echo ""
	echo " Usage: $(basename "$0") temps [fahrenheit|kelvin]"
	echo ""
	echo " Measures CPU temperature of Raspberry Pi"
	echo ""
	echo " Example:"
	echo " $(basename "$0") temps"
	echo ""
	echo " 60°C"
	echo ""
	echo " $(basename "$0") temps fahrenheit"
	echo ""
	echo " 140°F"
	echo " $(basename "$0") temps kelvin"
	echo ""
	echo " 333°K"
}
