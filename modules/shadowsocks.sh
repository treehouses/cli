function shadowsocks {
  checkroot

  local name port name_conf

  if [ ! -d /etc/shadowsocks-libev ]; then
    mkdir /etc/shadowsocks-libev
  fi
  
  if [ $# -eq 0 ]; then
    shadowsocks list
  fi
  
  case "$1" in
    list)
      checkargn $# 1

      echo
      echo "Config:"
      ls /etc/shadowsocks-libev/*.json |\
        sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g' -e 's/config//g'
      echo

      if [ -z "$(pidof ss-local)" ]; then
        echo "No instance of shadowsocks client running."
      else
        echo "Running:"
        echo
        for pid in $(pidof ss-local)
        do
          name="$(ps ax | grep -E "^ *$pid" |\
            awk '{print $7}' |\
            sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g')"
          port="$(lsof -i -P -n |\
            grep LISTEN | grep $pid |\
            awk '{print $9}' | cut -d ":" -f 2)"
          printf "%s\t\t%s\n" "$name" "$port"
        done
      fi
      echo

      if systemctl | grep shadowsocks-libev-local | grep -q failed; then
        echo "Failed:"
        echo
        name="$(systemctl |\
          grep shadowsocks-libev-local | grep failed |\
          awk '{print $2}' | cut -d "@" -f 2 | cut -d "." -f 1)"
        for i in $name 
        do
        printf "%s\n\tRun \`journalctl -u shadowsocks-libev-local@%s.service\` for more info.\n" "$i" "$i"
      done
      else
        echo "No instance of shadowsocks client failed."
      fi
      echo
      exit 0 ;;

    start | enable)
      checkargn $# 2

      echo
      for i in $(ls /etc/shadowsocks-libev/*.json)
      do
        if [ "$2" = "$(echo $i | cut -d "/" -f 4 | cut -d "." -f 1)" ]; then
          if [ "$1" = "start" ]; then
            systemctl start shadowsocks-libev-local@$2.service
            echo "$2 started."
          else
            systemctl enable shadowsocks-libev-local@$2.service
            echo "$2 enabled."
          fi
          echo
          exit 0
        fi
      done

      echo "Config \"$2\" not found."
      echo "Please do \`$BASENAME shadowsocks add $2\` first."
      echo
      exit 1;;

    restart)
      checkargn $# 2
      systemctl restart shadowsocks-libev-local@$2.service ;;

    stop)
      checkargn $# 2
      systemctl stop shadowsocks-libev-local@$2.service ;;

    disable)
      checkargn $# 2
      systemctl disable shadowsocks-libev-local@$2.service ;;

    add)
      echo
      echo "Existing config:"
      name="$(ls /etc/shadowsocks-libev/*.json |\
        sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g' -e 's/config//g')"
      echo $name
      echo
      read -p "Enter the name for your config:  " name_conf
      echo
      if echo $name_conf | grep -q ".json"; then
        name_conf="$(echo $name_conf | sed 's/.json//g')"
      fi

      if [ -f /etc/shadowsocks-libev/$name_conf.json ]; then
        echo "$name_conf.json already exists."
        echo "Abort."
        echo
        exit 1
      fi
      if [ -z $EDITOR ]; then
        vim /etc/shadowsocks-libev/$name_conf.json
      else
        $EDITOR /etc/shadowsocks-libev/$name_conf.json
      fi
      if [ -f /etc/shadowsocks-libev/$name_conf.json ]; then
        echo "Config saved."
        echo "Use \`$BASENAME shadowsocks start $name_conf\` to start client."
      else
        echo "Config not saved."
        echo
        exit 1
      fi
      echo

      if grep -q local_port | /etc/shadowsocks-libev/$name_conf.json; then
        cp "$TEMPLATES/network/proxychains4.conf" /etc/shadowsocks-libev/$name_conf.conf
        echo "socks5 127.0.0.1 $(grep local_port /etc/shadowsocks-libev/$name_conf.json |\
          awk '{print $2}' | sed 's/,//g')" >> /etc/shadowsocks-libev/$name_conf.conf
      else
        echo "The Config is not valid."
        echo "Abort."
        exit 1
      fi
      ;;

    remove)
      checkargn $# 2
      if echo $2 | grep -q ".json"; then
        name="$(echo $2 | sed 's/.json//g')"
      else
        name="$2"
      fi
      rm -rf /etc/shadowsocks-libev/$name.json
      ;;

    *)
      echo "Error: No option as $1."
      shadowsocks_help 
      exit 1;;
  esac
}

function shadowsocks_help {
  echo 
}
