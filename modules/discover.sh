function discover {
  local option ip mac mac_ip
  checkargn $# 2
  check_missing_packages "nmap"

  option=$1

  if [ $option = "scan" ] || [ $option = "ping" ] || [ $option = "ports" ]; then
    if [ -z $2 ]; then
      log_and_exit1 "You need to provide an IP address or URL for this command".
    fi
    ip=$2
  fi

  case $option in
    rpi)
      checkargn $# 1
      nmap --iflist | grep DC:A6:32
      nmap --iflist | grep B8:27:EB
      ;;
    wifi)
      checkargn $# 1
      checkroot
      iwlist wlan0 scanning | grep -E 'Cell |Encryption|Quality|Last beacon|ESSID'
      ;;
    scan)
      nmap -v -A -T4  $ip
      ;;
    interface)
      checkargn $# 1
      nmap --iflist
      ;;
    ping)
      nmap -sP $ip
      ;;
    ports)
      nmap --open $ip
      ;;
    mac)
      if ! [[ "$2" =~ ^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$ ]]; then
        log_and_exit1 "Invalid mac address"
      fi
      mac=$2
      mac_ip=$(arp -n |grep -i "$mac" |awk '{print $1}')
      if [ -z "$mac_ip" ]
      then
        echo " We can't find  ip address with this mac address since it is not on arp table."
      else
        echo " $mac_ip"
      fi
      ;;
    gateway)
      gateway_ip="$(ip route show |\
        grep -o -E "via [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | awk '{print $2}')"
      if [ $# -eq 1 ]; then
        if [ ! -z "$gateway_ip" ]; then
          echo "ip address: $gateway_ip"
          if networkmode | grep -q wifi; then
            iwgetid | cut -d " " -f 2-
          fi
          echo
          nmap --open $gateway_ip | sed '1,4d' | head -n -2
        else
          echo "Not found"
        fi
      else
        case "$2" in
          list)
            ip="$(nmap -sn "$gateway_ip/24" |\
              grep -o -E '(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])')"
            for i in $ip; do
              printf "%s\t\t%s\n" "$i" "$(nmap -sn $i |\
                grep -o -E "([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})")"
            done ;;
          *)
            echo "No option as $2"
            discover_help && exit 1 ;;
        esac
      fi ;;
    self)
      local i port program
      echo "IP address:"
      for i in $(hostname -I); do
        if echo $i | grep -q -E "^169.254" || echo $i | grep -q -E "^172"; then
          continue
        fi
        echo $i
      done
      echo
      echo "MAC address:"
      echo
      local interfaces="eth0 wlan0 ap0 usb0"
      for i in $interfaces; do
        if ip link show $i 2>/dev/null 1>&2; then
          printf "%s:\t%s\n" "$i" "$(ip link show $i | grep link | awk '{print $2}')"
        fi
      done
      echo
      echo "Ports:"
      local IFS=$'\n'
      for i in $(lsof -nP -i | grep LISTEN); do
        if echo $i | grep -q IPv6 && lsof -nP -i |\
          grep LISTEN | grep IPv4 |\
          grep -q "$(echo $i | awk '{print $1}')"; then
          continue
        fi
        port="$(echo $i | awk '{print $9}' | grep -o -E "[0-9]+$")"
        program="$(echo $i | awk '{print $1}')"
        printf "%15s%15s\n" "$program" "$port"
      done ;;
    *)
      echo "Unknown operation provided." 1>&2
      discover_help
      exit 1
      ;;
  esac
}


function discover_help {
  echo
  echo "Usage: $BASENAME discover <rpi|wifi|interface|scan|ping|ports|gateway|mac>"
  echo
  echo "Scans the network provdied and shows the open ports. Can scan for all raspberry pis on the network as well."
  echo
  echo "Example:"
  echo " $BASENAME discover rpi"
  echo "    Detects raspberry pis on the network."
  echo
  echo " $BASENAME discover wifi"
  echo "    Detects devices hosting wifi."
  echo
  echo " $BASENAME discover interface"
  echo "    Displays the host interfaces and routes on the network."
  echo
  echo " $BASENAME discover scan 192.168.7.149"
  echo "    Performs a network scan of the provided ip address."
  echo " $BASENAME discover scan scanme.nmap.org"
  echo "    Performs a network scan of the provided url."
  echo
  echo " $BASENAME discover ping [ipaddress|url]"
  echo "                    .... 192.168.7.149"
  echo "                    ....  google.com"
  echo "    Displays servers and devices running on network provided."
  echo
  echo " $BASENAME discover ports [ipaddress|url]"
  echo "                    .... 192.168.7.149"
  echo "                    .... scanme.nmap.org"
  echo "    Displays open ports."
  echo
  echo " $BASENAME discover mac b8:29:eb:9f:42:8b "
  echo "    Find the ip address of mac address."
  echo
  echo " $BASENAME discover gateway"
  echo "    Find ip address and opened ports of the gateway"
  echo
  echo " $BASENAME discover gateway list"
  echo "    Find the ip and mac address of devices in the network"
  echo
  echo " $BASENAME discover self"
  echo "    Display ip, mac address and ports in use of rpi"
  echo
}
