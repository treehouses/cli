function redirect {
  checkroot
 
  if [ $# -eq 0 ]; then
    redirect_help
    exit 1
  fi

  case "$1" in
    list)
        checkargn $# 1 
        ls /etc/dnsmasq.d/ --ignore="README"
        ;;
    add)
        checkargn $# 2
        echo "address=/$2/127.0.1.1" > /etc/dnsmasq.d/$2
        systemctl try-restart dnsmasq.service || systemctl start dnsmasq.service
        echo "$2 added."
        ;;
    remove)
        checkargn $# 2
        for i in /etc/dnsmasq.d/* 
        do
          if [ "$i" == "$2" ] && [ "$2" != "README" ]; then
            rm -rf /etc/dnsmasq.d/$2
            systemctl try-restart dnsmasq.service || systemctl start dnsmasq.service
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

function redirect_help {
  echo
  echo "Usage:  $BASENAME redirect [list|add|remove] <url>"
  echo
  echo "        $BASENAME redirect list           lists all that will be redirected"
  echo 
  echo "        $BASENAME redirect add [url]      add an url for hostname redirection"
  echo
  echo "        $BASENAME redirect remove [url]   remove an url for hostname redirection"
  echo
}
