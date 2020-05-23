function sshtunnel {
  local portinterval host hostname portssh portweb portcouchdb
  local portnewcouchdb portmunin keys option value status
  checkroot
  # checkargn $# 3
  # portinterval="$3"
  host="$4"

  if { [ ! -f "/etc/tunnel" ] || [ ! -f "/etc/cron.d/autossh" ]; }  && [ "$1" != "add" ]; then
    echo "Error: no tunnel has been set up."
    echo "Run '$BASENAME sshtunnel add' to add a key for the tunnel."
    exit 1
  fi

  # default host
  if [ -z "$host" ]; then
    host="ole@pirate.ole.org"
  fi

  hostname=$(echo "$host" | tr "@" \\n | sed -n 2p)

  case "$1" in
    add)
      case "$2" in
        tunnels)
          portinterval="$3"
          if [ -z "$portinterval" ]; then
            echo "Error: A port interval is required"
            exit 1
          fi

          # default list of ports
          portssh=$((portinterval + 22))
          portweb=$((portinterval + 80))
          portcouchdb=$((portinterval + 84))
          portnewcouchdb=$((portinterval + 82))
          portmunin=$((portinterval + 49))

          if [ ! -f "/root/.ssh/id_rsa" ]; then
            ssh-keygen -q -N "" > "$LOGFILE" < /dev/zero
          fi

          cat /root/.ssh/id_rsa.pub

          keys=$(ssh-keyscan -H "$hostname" 2>"$LOGFILE")
          while read -r key; do
            if ! grep -q "$key" /root/.ssh/known_hosts 2>"$LOGFILE"; then
                echo "$key" >> /root/.ssh/known_hosts
            fi
          done <<< "$keys"      

          # write to /etc/tunnel
          {
            echo "#!/bin/bash"
            echo
            echo "/usr/bin/autossh -f -T -N -q -4 -M $portinterval \\"
            echo "-R $portssh:127.0.1.1:22 \\"
            echo "-R $portcouchdb:127.0.1.1:5984 \\"
            echo "-R $portweb:127.0.1.1:80 \\"
            echo "-R $portnewcouchdb:127.0.1.1:2200 \\"
            echo "-R $portmunin:127.0.1.1:4949 \\"
            echo "$host"
          } > /etc/tunnel

          chmod +x /etc/tunnel

          if ! grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>"$LOGFILE"; then
            sed -i 's/^exit 0/if [ -f "\/etc\/tunnel" ];\nthen\n  \/etc\/tunnel\nfi\nexit 0/g' /etc/rc.local
          fi

          {
            echo "MAILTO=root"
            echo "*/5 * * * * root if [ ! "$\(pidof autossh\)" ]; then /etc/tunnel; fi"
          } > /etc/cron.d/autossh
          ;;
        port)
          name=$3
          actual=$4
          offset=$5
          if [ -f /etc/ports-list ]; then
            if ! grep -Fq "$name" /etc/ports-list; then
              echo "$name=$actual,$offset" >> /etc/ports-list
            else
              echo "port already added"
            fi
          else
            echo "Error: /etc/ports-list not found"
            exit 1
          fi
          ;;
        *)
          echo "Error: unknown command"
          echo "Usage: $BASENAME sshtunnel add <tunnels | port>"
          exit 1
          ;;
      esac
      ;;
    remove)
      case "$2" in
        all)
          if [ -f /etc/tunnel ]; then
            rm -rf /etc/tunnel
          fi

          if [ -f /etc/cron.d/autossh ]; then
            rm -rf /etc/cron.d/autossh
          fi

          pkill -3 autossh
          echo -e "${GREEN}Removed${NC}"
          ;;
        *)
          # remove specific port (not port interval or offset)
          port=$2
          if [ -f /etc/tunnel ]; then
            if grep -Fq "127.0.1.1:$port" /etc/tunnel; then
              sed -i "/$port/d" /etc/tunnel
              echo "Removed $port from /etc/tunnel"
            else
              echo "Error: port not found in /etc/tunnel"
              exit 1
            fi
          else
            echo "Error: /etc/tunnel not found"
            exit 1
          fi
          ;;
      esac
      ;;
    list | "")
      if [ -f /etc/tunnel ]; then
        echo "Ports:"
        echo "  local   -> external"

        while read -r -u 9 line; do
          if echo $line | grep -oPq "(?<=\-R )(.*?) "; then
            local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
            external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
            echo "    $local -> $external"
          fi
        done 9< /etc/tunnel

        echo "Host: $(sed -r "s/.* (.*?)$/\1/g" /etc/tunnel | tail -n1)"
      else
        echo "Error: a tunnel has not been set up yet"
        exit 1
      fi
      ;;
    check)
      if [ -f "/etc/tunnel" ]; then
        echo -e "[${GREEN}OK${NC}] /etc/tunnel"
      else
        echo -e "[${RED}MISSING${NC}] /etc/tunnel"
      fi

      if [ -f "/etc/cron.d/autossh" ]; then
        echo -e "[${GREEN}OK${NC}] /etc/cron.d/autossh"
      else
        echo -e "[${RED}MISSING${NC}] /etc/cron.d/autossh"
      fi

      if grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>"$LOGFILE"; then
        echo -e "[${GREEN}OK${NC}] /etc/rc.local starts /etc/tunnel if exists"
      else
        echo -e "[${RED}MISSING${NC}] /etc/rc.local doesn't start /etc/tunnel if exists"
      fi

      if [ "$(pidof autossh)" ]; then
        echo -e "[${GREEN}OK${NC}] autossh pid: $(pidof autossh)"
      else
        echo -e "[${RED}MISSING${NC}] autossh not running"
      fi
      ;;
    key)
      if [ ! -f "/root/.ssh/id_rsa" ]; then
          ssh-keygen -q -N "" > "$LOGFILE" < /dev/zero
      fi
      cat /root/.ssh/id_rsa.pub
      ;;
    notice)
      case "$2" in
        on)
          cp "$TEMPLATES/network/tunnel_report.sh" /etc/tunnel_report.sh
          if [ ! -f "/etc/cron.d/tunnel_report" ]; then
            echo "*/1 * * * * root if [ -f \"/etc/tunnel\" ]; then /etc/tunnel_report.sh; fi" > /etc/cron.d/tunnel_report
          fi
          if [ ! -f "/etc/tunnel_report_channels.txt" ]; then
            echo "https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages" >> /etc/tunnel_report_channels.txt
          fi
          echo "OK."
          ;;
        add)
          value="$3"
          if [ -z "$value" ]; then
            echo "Error: You must specify a channel URL"
            exit 1
          fi

          echo "$value" >> /etc/tunnel_report_channels.txt
          echo "OK."
          ;;
        delete)
          value="$3"
          if [ -z "$value" ]; then
            echo "Error: You must specify a channel URL"
            exit 1
          fi

          value=$(echo $value | sed 's/\//\\\//g')
          sed -i "/^$value/d" /etc/tunnel_report_channels.txt
          echo "OK."
          ;;
        list)
          if [ -f "/etc/tunnel_report_channels.txt" ]; then
            cat /etc/tunnel_report_channels.txt
          else
            echo "No channels found. No message send"
          fi
          ;;
        off)
          rm -rf /etc/tunnel_report.sh /etc/cron.d/tunnel_report /etc/tunnel_report_channels.txt || true
          echo "OK."
          ;;
        now)
          message="$(sed -r "s/.* (.*?)$/\1/g" /etc/tunnel | tail -n1):$(grep -oP "(?<=\-M )(.*?) " /etc/tunnel)\n"
          while read -r -u 9 line; do
            if echo $line | grep -oPq "(?<=\-R )(.*?) "; then
              local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
              external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
              message+="$external:$local "
            fi
          done 9< /etc/tunnel
          message+="\n\`$(date -u +"%Y-%m-%d %H:%M:%S %Z")\` $(treehouses networkmode)"
          treehouses feedback $message
          ;;
        "")
          if [ -f "/etc/cron.d/tunnel_report" ]; then
            echo "Status: on"
          else
            echo "Status: off"
          fi
          ;;
        *)
          echo "Error: only 'on' and 'off' options are supported."
          exit 1
          ;;
      esac
      ;;
    *)
      echo "Error: only 'add', 'remove', 'list', 'check', 'key', 'notice' options are supported";
      exit 1
      ;;
  esac
}

function sshtunnel_help {
  echo
  echo "Usage: $BASENAME sshtunnel <add|remove|list|key|notice> <portinterval> [user@host]"
  echo
  echo "Helps setting up a sshtunnel"
  echo
  echo "Example:"
  echo "  $BASENAME sshtunnel add 65400 user@server.org"
  echo "      This will set up autossh with the host 'user@server.org' and open the following tunnels"
  echo "      127.0.1.1:22 -> host:65422"
  echo "      127.0.1.1:80 -> host:65480"
  echo "      127.0.1.1:2200 -> host:65482"
  echo "      127.0.1.1:4949 -> host:65449"
  echo "      127.0.1.1:5984 -> host:65484"
  echo
  echo "  $BASENAME sshtunnel remove"
  echo "      This will stop the ssh tunnels and remove the extra files added"
  echo
  echo "  $BASENAME sshtunnel list"
  echo "      This will output the tunneled ports and to which host"
  echo
  echo "  $BASENAME sshtunnel check"
  echo "      This will run a checklist and report back the results"
  echo
  echo "  $BASENAME sshtunnel key"
  echo "      This will show the public key."
  echo
  echo "  $BASENAME sshtunnel notice <on|off|add|delete|list|now> [api_url]"
  echo "      Enables or disables the propagation of the sshtunnel ports to gitter"
  echo
}
