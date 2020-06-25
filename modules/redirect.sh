function redirect {
  checkroot
 
  if [ $# -eq 0 ]; then
    redirect_help
    exit 1
  fi

  case "$1" in
    list)
        checkargn $# 1 
        ls /etc/dnsmasq.d/ | grep -v README
        ;;
    add)
        checkargn $# 2
        echo "address=/$2/127.0.1.1" > /etc/dnsmasq.d/$2
        systemctl restart dnsmasq.service
        ;;
    remove)
        checkargn $# 2
        if ls /etc/dnsmasq.d/ | grep -q $2; then
          for i in $(ls /etc/dnsmasq.d/ | grep -v README)
          do
            if [ "$i" == "$2" ]; then
              rm -rf /etc/dnsmasq.d/$2
              systemctl restart dnsmasq.service
              exit 0
            fi
          done
        fi 
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
}
