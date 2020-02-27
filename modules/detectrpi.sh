function detectrpi {
  rpimodel=$(tr -d '\0' </sys/firmware/devicetree/base/model)
  if [ "$1" == "" ]
  then
  	  echo "$rpimodel"
  elif [ "$1"  != "" ]
  then
  	  log_and_exit1 "Error: only 'detectrpi' command supported"
  else
	  echo "Not a Raspberry pi"
  fi
}

function detectrpi_help {
  echo
  echo "Usage: $BASENAME detectrpi"
  echo
  echo "Detects the Raspberry pi version"
  echo
  echo "Example:"
  echo "  $BASENAME detectrpi"
  echo "      Prints the Raspberry Pi model"
  echo
}
