#!/bin/bash

function faketemperature () {
	reading=$(vcgencmd measure_temp)
	number0=${reading:5}
	number=${number0/%??/}
	echo $number"°C"

	case "$1" in
		"") echo $number"°C"
		;;

		"kelvin")
		echo "$number"°C" + 273.15"
		;;

		"farenheit")
		#echo "($number"°C"" x 9/5) + 32"
		echo "to be determined"
		;;

	esac
}

function faketemperature_help {
	echo
	echo "Usage: $(basename "$0") temperature [fehrenheit|kelvin]"
	echo
	echo "Displays CPU temperature of a Raspberry Pi"
	echo
	echo "Example:"
	echo "$(basename "$0") temperature"
	echo
	echo "1250°C"
	echo
	echo "$(basename "$0") temperature fahrenheit"
	echo
	echo "2000°F"
}
