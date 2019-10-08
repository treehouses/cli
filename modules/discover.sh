function discover {

  ip=$1
  nmap $ip
  

}

function discover_help {
  echo ""
  echo "Usage: $(basename "$0") speedtest"
  echo ""
  echo "Scans the network provided and shows the open ports"
  echo ""
  echo "Example:"
  echo " $(basename "$0") discover 192.168.7.151"
  echo ""

}
