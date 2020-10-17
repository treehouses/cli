function dhcp () {
  checkrpi 
  checkargn $# 1
  # ps xauf | grep dhcp
  case "$1" in
    "list")
      cat /var/lib/misc/dnsmasq.leases|cut -d' ' -f3-
      ;;
    "")
      if ps xauf | grep dhcp > /dev/null 2>&1
        then
	  echo "dhcp is on"
	else
	  echo "dhcp is off"
      fi
      ;;
    "status")
      OUTPUT=$(cat /var/lib/misc/dnsmasq.leases|wc -l)
      echo "dhcp devices: $OUTPUT"
      ;;
    *)
      log_help_and_exit1 "Error: invalid" dhcp
      ;;
  esac
}

function dhcp_help {
  echo
  echo "Usage: $BASENAME dhcp [list]"
  echo
  echo "dhcp details for Raspberry Pi"
  echo
  echo "Example:"
  echo "  $BASENAME dhcp"
  echo "  47.2"
  echo
  echo "  $BASENAME dhcp list"
  echo "  47.2°C"
}