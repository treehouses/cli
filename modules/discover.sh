function discover {

  ip=$1
  nmap $ip
  

}

function discover_help {
  echo ""
  echo "Usage: $(basename "$0") speedtest"
  echo ""


}
