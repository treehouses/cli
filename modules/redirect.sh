function redirect {
  checkroot

  local ip
 
  if [ $# -eq 0 ]; then
    redirect_help
    exit 0
  fi

  case "$1" in
    list)
      checkargn $# 1 
      if [ "$(find /etc/dnsmasq.d | wc -w)" -eq 1 ]; then
        echo "No url to be redirected"
      else
        ls /etc/dnsmasq.d/ --ignore="README"
      fi
      ;;
    start)
      ip="$(check_ip)" || exit 1
      for i in /etc/dnsmasq.d/*
      do
        echo "$(cut -d "/" -f -2 $i)/$ip" > $i
      done
      systemctl restart dnsmasq.service && echo "redirect started."
      ;;
    add)
      checkargn $# 2
      ip="$(check_ip)" || exit 1
      echo "address=/$2/$ip" > /etc/dnsmasq.d/$2
      systemctl restart dnsmasq.service && echo "$2 added."
      ;;
    remove)
      checkargn $# 2
      for i in /etc/dnsmasq.d/*
      do
        if [ "$i" == "/etc/dnsmasq.d/$2" ] && [ "$2" != "README" ]; then
          rm -rf $i
          systemctl restart dnsmasq.service
          echo "$2 removed."
          exit 0
        fi
      done
      echo "$2 not found!"
      redirect_help
      exit 1
      ;;
    *)
      echo "No such option as $1!"
      redirect_help
      exit 1
      ;;  
  esac
}

function check_ip {
  ip="$(nmap -sn "$(ip route show | grep 'via' | awk '{print $3}')/24" 2>/dev/null |\
    grep -i "$(</etc/hostname)" | awk '{print $6}' | sed -e 's/(//g' -e 's/)//g')"
  if [ -z "$ip" ]; then
    case "$(networkmode)" in
      *wifi*)
        ip="$(get_ipv4_ip wlan0)" ;;
      *eth* | *ap*)
        ip="$(get_ipv4_ip eth0)" ;;
      *bridge*)
        ip="$(get_ipv4_ip ap0)" ;;
      *)
        exit 1 ;;
    esac
  fi
  echo "$ip"
}

function redirect_help {
  echo
  echo "Usage:  $BASENAME redirect [list|add|remove] <url>"
  echo
  echo "        $BASENAME redirect list           lists all that will be redirected"
  echo
  echo "        $BASENAME redirect start          start dnsmasq for redirection"
  echo 
  echo "        $BASENAME redirect add [url]      add an url for hostname redirection"
  echo
  echo "        $BASENAME redirect remove [url]   remove an url for hostname redirection"
  echo
}
