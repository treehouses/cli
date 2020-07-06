function shadowsocks {
  checkroot

  local name port name_conf running location

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
            echo "Use \`$BASENAME shadowsocks enter $2\` to enter shell session proxied by shadowsocks client."
          else
            systemctl enable shadowsocks-libev-local@$2.service
            echo "$2 enabled."
          fi
          echo

          if [ ! -f /etc/shadowsocks-libev/$2.conf ]; then
            if grep -q local_port /etc/shadowsocks-libev/$2.json; then
              cp "$TEMPLATES/network/proxychains4.conf" /etc/shadowsocks-libev/$2.conf
              echo "socks5 127.0.0.1 $(grep local_port /etc/shadowsocks-libev/$2.json |\
                awk '{print $2}' | sed 's/,//g')" >> /etc/shadowsocks-libev/$name_conf.conf
            else
              echo "Config not valid."
              echo "You may be unable to enter proxied shell session."
              echo 
              exit 1
            fi
          fi
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
      if echo $name_conf | grep -q ".json"; then
        name_conf="$(echo $name_conf | sed 's/.json//g')"
      fi

      if [ -f /etc/shadowsocks-libev/$name_conf.json ]; then
        echo "$name_conf.json already exists."
        echo "Abort."
        echo
        exit 1
      fi
      
      cp "$TEMPLATES/network/shadowsocks.json" /etc/shadowsocks-libev/$name_conf.json
      if [ -z "$EDITOR" ]; then
        vim /etc/shadowsocks-libev/$name_conf.json
      else
        $EDITOR /etc/shadowsocks-libev/$name_conf.json
      fi
      echo

      if grep -q local_port /etc/shadowsocks-libev/$name_conf.json; then
        cp "$TEMPLATES/network/proxychains4.conf" /etc/shadowsocks-libev/$name_conf.conf
        echo "socks5 127.0.0.1 $(grep local_port /etc/shadowsocks-libev/$name_conf.json |\
          awk '{print $2}' | sed 's/,//g')" >> /etc/shadowsocks-libev/$name_conf.conf
        echo "Config saved."
        echo "Use \`$BASENAME shadowsocks start $name_conf\` to start client."
        echo
        exit 0
      else
        rm -rf /etc/shadowsocks-libev/$name_conf.json
        echo "The config is not valid."
        echo "Abort."
        echo
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

    enter)
      checkargn $# 2

      if echo $2 | grep -q ".json"; then
        name="$(echo $2 | sed 's/.json//g')"
      else
        name="$2"
      fi

      if [ ! -z "$(pidof ss-local)" ]; then
        for pid in $(pidof ss-local)
        do
          running="$(ps ax | grep -E "^ *$pid" |\
            awk '{print $7}' |\
            sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g')"
          if [ "$name" == "$running" ]; then
            break
          fi
        done
        echo "$name is not running!"
        echo "Please do \`$BASENAME shadowsocks start $name\` first."
        exit 1
      else
        echo "No instance of Shadowsocks client running!"
        echo "Abort." && exit 1
      fi
      
      if -f /etc/shadowsocks-libev/$name.conf; then
        proxychains4 -q -f /etc/shadowsocks-libev/$name.conf $SHELL
        echo "Session terminated."
      else
        echo "Proxychains4 configuration file not found."
        echo "Abort."
        exit 1
      fi
      exit 0 ;;

    *)
      echo "Error: No option as $1."
      shadowsocks_help 
      exit 1;;
  esac
}

function shadowsocks_help {
  echo 
}