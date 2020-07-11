function ssh {
  local status
  checkroot
  checkargn $# 1
  status=$1
  case $status in
    "on")
      enable_service ssh
      start_service ssh
      echo "Success: the ssh service has been started and enabled when the system boots"
      ;;
    "off")
      disable_service ssh
      stop_service ssh
      echo "Success: the ssh service has been stopped and disabled when the system boots."
      ;;
    "fingerprint")
      ssh-keygen -l -E sha256 -f /etc/ssh/ssh_host_ecdsa_key.pub | cut -c5-54
      ;;
    "")
      last | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
      ;;
    *)
      echo "Error: only '', 'on', 'off', or 'fingerprint' options are supported"
      ;;
  esac
}

function ssh_help {
  echo
  echo "Usage: $BASENAME ssh [on|off|fingerprint]"
  echo
  echo "Enables or disables the SSH service"
  echo
  echo "Example:"
  echo "  $BASENAME ssh"
  echo "      The last SSH connections from ipaddresses will be shown"
  echo
  echo "  $BASENAME ssh on"
  echo "      The SSH service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using SSH."
  echo
  echo "  $BASENAME ssh off"
  echo "      The SSH service will be disabled."
  echo 
  echo "  $BASENAME ssh fingerprint"
  echo "      The SSH fingerprint will be printed from when the session was first established."
  echo
}
