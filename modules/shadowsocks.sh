function shadowsocks {
  checkroot
  check_missing_packages "shadowsocks-libev"
  check_missing_packages "proxychains4"

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
      find /etc/shadowsocks-libev/*.json |\
        sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g' -e 's/config//g'
      echo

      if [ -z "$(pidof ss-local)" ]; then
        echo "No instance of shadowsocks client running."
      else
        echo "Running:"
        echo
        printf "%20s%15s%25s\n" "CONFIG" "PORT" "LOCATION"
        for pid in $(pidof ss-local)
        do
          name="$(ps ax | grep -E "^ *$pid" |\
            awk '{print $7}' |\
            sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g')"
          port="$(lsof -i -P -n |\
            grep LISTEN | grep $pid |\
            awk '{print $9}' | cut -d ":" -f 2)"
          if [ -f /etc/shadowsocks-libev/$name.conf ]; then
            location="$(proxychains4 -f /etc/shadowsocks-libev/$name.conf -q curl -s ipinfo.io |\
              grep \"country\" | cut -d ":" -f 2 |\
              sed -e 's/"//g' -e 's/,//g')"
            location="$location -$(proxychains4 -f /etc/shadowsocks-libev/$name.conf -q curl -s ipinfo.io |\
              grep \"region\" | cut -d ":" -f 2 |\
              sed -e 's/"//g' -e 's/,//g')"
          else
            location="$(proxychains4 -q curl -s ipinfo.io |\
              grep \"country\" | cut -d ":" -f 2 |\
              sed -e 's/"//g' -e 's/,//g')"
            location="$location - $(proxychains4 -q curl -s ipinfo.io |\
              grep \"region\" | cut -d ":" -f 2 |\
              sed -e 's/"//g' -e 's/,//g')"
          fi
          printf "%20s%15s%25s\n" "$name" "$port" "$location"
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
      for i in /etc/shadowsocks-libev/*.json
      do
        if [ "$2" = "$(echo $i | cut -d "/" -f 4 | cut -d "." -f 1)" ]; then
          if [ "$1" = "start" ]; then
            systemctl start shadowsocks-libev-local@$2.service
            if systemctl --quiet is-active shadowsocks-libev-local@$2.service; then
              echo "$2 started."
              echo "Use \`$BASENAME shadowsocks enter $2\` to enter shell session proxied by shadowsocks client."
            else
              log_comment_and_exit1 "ERROR: $2 fails to start." "Please check your config."
            fi
          else
            systemctl enable shadowsocks-libev-local@$2.service --quiet
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
      systemctl restart shadowsocks-libev-local@$2.service --quiet
      echo "$2 restarted." ;;

    stop)
      checkargn $# 2
      systemctl stop shadowsocks-libev-local@$2.service --quiet
      echo "$2 stopped." ;;

    disable)
      checkargn $# 2
      systemctl disable shadowsocks-libev-local@$2.service --quiet
      echo "$2 disabled" ;;

    add)
      if [ $# -eq 2 ] && [ -f "$2" ]; then
        name_conf="$(echo $2 | sed -e 's/json//g' -e 's/\.//g' -e 's/\///g' )"

        if [ -f /etc/shadowsocks-libev/$name_conf.json ]; then
          echo "$name_conf.json already exists."
          echo "Abort."
          echo
          exit 1
        fi
        if ! jq -e . >/dev/null 2>&1 <<< "$(<$2)"; then
          log_comment_and_exit1 "Error: invalid json format" "Abort."
        fi
        cp "$2" /etc/shadowsocks-libev/$name_conf.json
      elif [ $# -gt 2 ]; then
        file=$(mktemp)
        echo "$@" > $file
        sed -i 's/add//' $file
        shadowsocks add $file
      elif [ ! -z "$2" ] && [ ! -f "$2" ]; then
        log_comment_and_exit1 "Error: invalid json format" "Abort."
      else
        checkargn $# 1
        echo
        echo "Existing config:"
        name="$(find /etc/shadowsocks-libev/*.json |\
          sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g' -e 's/config//g')"
        echo $name
        echo
        read -r -p "Enter the name for your config:  " name_conf
        if echo $name_conf | grep -q ".json"; then
          name_conf="${name_conf//.json/}"
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

        if [ -z "$(diff $TEMPLATES/network/shadowsocks.json /etc/shadowsocks-libev/$name_conf.json)" ]; then
          echo "Config not saved."
          rm -rf /etc/shadowsocks-libev/$name_conf.json
          log_and_exit1 "Abort."
        fi
      fi

      if grep -q local_port /etc/shadowsocks-libev/$name_conf.json; then
        cp "$TEMPLATES/network/proxychains4.conf" /etc/shadowsocks-libev/$name_conf.conf
        echo "socks5 127.0.0.1 $(grep -o -E "\"local_port\": *[0-9]+" /etc/shadowsocks-libev/$name_conf.json |\
          grep -o -E "[0-9]+")" >> /etc/shadowsocks-libev/$name_conf.conf
        echo "Config named \"$name_conf\" saved."
        echo "Use \`$BASENAME shadowsocks start $name_conf\` to start client."
        echo
        exit 0
      else
        rm -rf /etc/shadowsocks-libev/$name_conf.json
        echo "The config is not valid."
        echo "Abort."
        echo
        exit 1
      fi ;;

    remove)
      checkargn $# 2
      if echo $2 | grep -q ".json"; then
        name="${2//.json/}"
      else
        name="$2"
      fi
      rm -rf /etc/shadowsocks-libev/$name.*
      shadowsocks stop $name
      shadowsocks disable $name
      echo "$name removed."
      ;;

    enter)
      checkargn $# 2
      if echo $2 | grep -q ".json"; then
        name="${2//.json/}"
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
            if [ -f /etc/shadowsocks-libev/$name.conf ]; then
              proxychains4 -q -f /etc/shadowsocks-libev/$name.conf $SHELL
              echo "$name Session terminated."
              exit 0
            else
              log_comment_and_exit1 "Error: Proxychains4 configuration file not found." "Abort."
            fi
            break
          fi
        done
        log_comment_and_exit1 "Error: $name is not running!" "Please do \`$BASENAME shadowsocks start $name\` first."
      else
        log_comment_and_exit1 "Error: no instance of Shadowsocks client running!" "Abort."
      fi ;;
      
    profile)
      find /etc/shadowsocks-libev/*.json |\
        sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g' -e 's/config//g'
      exit 0 ;;
      
    running)
      local name port
      if [ -z "$(pidof ss-local)" ]; then
        echo "No instance of shadowsocks client running."
      else
        printf "%20s%10s\n" "CONFIG" "PORT"
        for pid in $(pidof ss-local)
        do
          name="$(ps ax | grep -E "^ *$pid" |\
            awk '{print $7}' |\
            sed -e 's/\/etc\/shadowsocks-libev\///g' -e 's/.json//g')"
          port="$(lsof -i -P -n |\
            grep LISTEN | grep $pid |\
            awk '{print $9}' | cut -d ":" -f 2)"
          printf "%20s%10s\n" "$name" "$port"
        done
      fi
      exit 0 ;;

    *)
      log_help_and_exit1 "Error: No option as $1." shadowsocks
      ;;
  esac
}

function shadowsocks_help {
  echo 
  echo "Usage:  $BASENAME shadowsocks [add|disable|enable|enter]"
  echo "                        [list|restart|remove|start|stop]"
  echo
  echo "        $BASENAME shadowsocks list"
  echo "                          list all information regarding shadowsocks clients"
  echo "        $BASENAME shadowsocks add <json file>"
  echo "                          add configuration file for shadowsocks clients"
  echo "        $BASENAME shadowsocks enter"
  echo "                          enter a proxied shell session by shadowsocks client"
  echo "        $BASENAME shadowsocks enable/disable"
  echo "                          enable/disable autorun for shadowsocks clients"
  echo "        $BASENAME shadowsocks start/stop/restart"
  echo "                          start/stop/restart shadowsocks clients"
  echo "        $BASENAME shadowsocks remove"
  echo "                          remove shadowsocks clients config json"
  echo
}
