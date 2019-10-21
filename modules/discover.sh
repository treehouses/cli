#!/bin/bash

function discover {
  check_missing_packages "nmap"
  #/usr/bin/nmap "$@"
  
  if [ "$#" -gt 2 ]
  then 
    echo "Too many arguments."
    discover_help
    exit 1
  fi 

  option=$1
<<<<<<< HEAD

  if [ $option = "scan" ] || [ $option = "ping" ] || [ $option = "ports" ]
=======
  if [ $option = "ip" ] || [ $option = "ping" ] || [ $option = "ports" ]
>>>>>>> 9581309d6c9f3f58586900ddf2f535b9fcaf52ee
  then
    if [ -z $2 ]
    then 
      echo "You need to provide an IP address or URL for this command".
      exit 1
    fi
    ip=$2
  fi
  
  case $option in
    rpi)
      if [ $# -gt 1 ]
      then
        echo "Too many arguments."
        discover_help
        exit 1
      fi
      nmap --iflist | grep DC:A6:32
      nmap --iflist | grep B8:27:EB
      ;;
    scan)
      nmap -v -A -T4  $ip
      ;;
    interface)
      if [ $# -gt 1 ]
      then
        echo "Too many arguments."
        discover_help
        exit 1
      fi 
      nmap --iflist
      ;; 
    ping)
      nmap -sP $ip
      ;;
    ports)
      nmap --open $ip
      ;;
    *)
      echo "Unknown operation provided." 1>&2
      discover_help
<<<<<<< HEAD
      exit 1
=======
      ;;
>>>>>>> 9581309d6c9f3f58586900ddf2f535b9fcaf52ee
  esac

}


function discover_help {
  echo ""
  echo "Usage: $(basename "$0") discover <rpi|scan|hostinterface|ping|ports ip|ping|ports[ipaddress|url]>"
  echo ""
  echo "Scans the network provdied and shows the open ports. Can scan for all raspberry pis on the network as well."
  echo ""
  echo "Example:"
  echo " $(basename "$0") discover rpi"
  echo "    Detects raspberry pis on the network."
  echo " $(basename "$0") discover scan 192.168.7.149"
  echo "    Performs a network scan of the provided ip address."
  echo " $(basename "$0") discover scan scanme.nmap.org"
  echo "    Performs a network scan of the provided url."
  echo " $(basename "$0") discover interface"
  echo "    Displays the host interfaces and routes on the network."
  echo " $(basename "$0") discover ping 192.168.7.149"
  echo "    Displays servers and devices running on network provided."
  echo " $(basename "$0") discover ports 192.168.7.149"
  echo "    Displays open ports."
  echo ""
}
