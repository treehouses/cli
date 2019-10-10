#!/bin/bash

function discover {
  option=$1
  if [ $option = "ip" ] || [ $option = "ping" ]
  then
    ip=$2
  fi

  case $option in
    rpi)
      nmap --iflist | grep DC:A6:32
      nmap --iflist | grep B8:27:EB
      ;;
    ip)
      nmap -v -A -T4  $ip
      ;;
    hostif)
      nmap --iflist
      ;; 
    ping)
      nmap -sP $ip
      ;;
    *)
      echo "Unknown operation provided." 1>&2
      discover_help
  esac

}


function discover_help {
  echo ""
  echo "Usage: $(basename "$0") discover <rpi|ip|hostif|ping ip|[ipaddress|url]>"
  echo ""
  echo "Scans the network provdied and shows the open ports. Can scan for all raspberry pis on the network as well."
  echo ""
  echo "Example:"
  echo " $(basename "$0") discover rpi"
  echo "    Detects raspberry pis on the network."
  echo " $(basename "$0") discover ip 192.168.7.149"
  echo "    Performs a network scan of the provided ip address."
  echo " $(basename "$0") discover ip scanme.nmap.org"
  echo "    Performs a network scan of the provided url."
  echo " $(basename "$0") discover hostif"
  echo "    Displays the host interfaces and routes on the network."
  echo " $(basename "$0") discover ping 192.168.7.149"
  echo "    Displays servers and devices running on network provided."
}
