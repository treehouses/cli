function sshtunnel {
  local portinterval host hostname portssh portweb portcouchdb
  local portnewcouchdb portmunin keys option value status
  checkroot

  if { [ ! -f "/etc/tunnel" ] || [ ! -f "/etc/cron.d/autossh" ]; }  && [ "$1" != "add" ]; then
    echo "Error: no tunnel has been set up"
    echo "Run '$BASENAME sshtunnel add host' to add a key for the tunnel"
    exit 1
  fi

  case "$1" in
    add)
      case "$2" in
        host)
          checkargn $# 4
          portinterval=$3
          host=$4
          if [ -z "$portinterval" ]; then
            echo "Error: a port interval is required"
            echo "Usage: $BASENAME sshtunnel add host <port interval> [host]"
            exit 1
          fi

          # host validation
          if [ -z "$host" ]; then
            host="ole@pirate.ole.org"
          elif ! echo $host | grep -q "[]@[]"; then
            echo "Error: invalid host"
            exit 1
          fi

          hostname=$(echo "$host" | tr "@" \\n | sed -n 2p)

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

          if [ ! -f /etc/tunnel ]; then
            {
              echo "#!/bin/bash"
            } > /etc/tunnel
          fi

          {
            echo
            echo "/usr/bin/autossh -f -T -N -q -4 -M $portinterval \\"
            echo "-R $portssh:127.0.1.1:22 \\"
            echo "-R $portcouchdb:127.0.1.1:5984 \\"
            echo "-R $portweb:127.0.1.1:80 \\"
            echo "-R $portnewcouchdb:127.0.1.1:2200 \\"
            echo "-R $portmunin:127.0.1.1:4949 \\"
            echo "$host"
          } >> /etc/tunnel

          chmod +x /etc/tunnel

          if ! grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>"$LOGFILE"; then
            sed -i 's/^exit 0/if [ -f "\/etc\/tunnel" ];\nthen\n  \/etc\/tunnel\nfi\nexit 0/g' /etc/rc.local
          fi

          {
            echo "MAILTO=root"
            echo "*/5 * * * * root if [ ! "$\(pidof autossh\)" ]; then /etc/tunnel; fi"
          } > /etc/cron.d/autossh

          pkill -3 autossh
          ;;
        port)
          if [ -f /etc/tunnel ]; then
            checkargn $# 5
            actual=$3
            offset=$4
            host=$5
            re='^[0-9]+$'

            if [ -z "$actual" ] || ! [[ $actual =~ $re ]]; then
              echo "Error: a numeric port is required"
              echo "Usage: $BASENAME sshtunnel add port <actual> <offset> [host]"
              exit 1
            elif [ -z "$offset" ] || ! [[ $offset =~ $re ]]; then
              echo "Error: a numeric offset is required"
              echo "Usage: $BASENAME sshtunnel add port <actual> <offset> [host]"
              exit 1
            fi

            # host validation
            if [ -z "$host" ]; then
              host="ole@pirate.ole.org"
            elif ! echo $host | grep -q "[]@[]"; then
              echo "Error: invalid host"
              exit 1
            fi

            # get port interval for given host
            found=false
            while read -r line; do
              if [[ $line =~ "/usr/bin/autossh" ]]; then
                portinterval=$(echo $line | grep -oP "(?<=\-M )(.*?) ")
              fi
              if [ ! -z "$portinterval" ] && [[ "$line" == "$host" ]]; then
                found=true
                break
              fi
              if [ ! -z "$portinterval" ] && [ -z "$line" ]; then
                found=false
                portinterval=""
              fi
            done < <(cat /etc/tunnel)

            if [ "$found" = true ]; then
              # check if port is already added
              found=false
              while read -r line; do
                if [[ $line =~ 127.0.1.1:$actual ]]; then
                  exists=yes
                fi
                if [ ! -z "$exists" ] && [[ "$line" == "$host" ]]; then
                  found=true
                  break
                fi
                if [ ! -z "$exists" ] && [ -z "$line" ]; then
                  found=false
                  exists=""
                fi
              done < <(cat /etc/tunnel)

              if [ "$found" = true ]; then
                echo "Port already exists"
              else
                sed -i "/^$host/i -R $((portinterval + offset)):127.0.1.1:$actual \\\\" /etc/tunnel
                echo "Added $actual -> $((portinterval + offset)) for host $host"
                pkill -3 autossh
              fi
            else
              echo "Host not found"
            fi
          else
            echo "Error: /etc/tunnel not found"
            exit 1
          fi
          ;;
        *)
          echo "Error: unknown command"
          echo "Usage: $BASENAME sshtunnel add <host | port>"
          exit 1
          ;;
      esac
      ;;
    remove)
      case "$2" in
        all)
          checkargn $# 2
          if [ -f /etc/tunnel ]; then
            rm -rf /etc/tunnel
          fi

          if [ -f /etc/cron.d/autossh ]; then
            rm -rf /etc/cron.d/autossh
          fi

          pkill -3 autossh
          echo -e "${GREEN}Removed${NC}"
          ;;
        port)
          checkargn $# 4
          port=$3
          host=$4

          if [ -z "$port" ]; then
            echo "Error: a port is required"
            echo "Usage: $BASENAME sshtunnel remove port <port> [host]"
            exit 1
          fi

          # host validation
          if [ -z "$host" ]; then
            host="ole@pirate.ole.org"
          elif ! echo $host | grep -q "[]@[]"; then
            echo "Error: invalid host"
            exit 1
          fi

          if [ -f /etc/tunnel ]; then
            counter=1
            found=false
            while read -r line; do
              if [[ $line =~ 127.0.1.1:$port ]]; then
                final=$counter
              fi
              if [ ! -z "$final" ] && [[ "$line" == "$host" ]]; then
                found=true
                break
              fi
              if [ ! -z "$final" ] && [ -z "$line" ]; then
                found=false
                final=""
              fi
              ((counter++))
            done < <(cat /etc/tunnel)

            if [ "$found" = true ]; then
              sed -i "$final d" /etc/tunnel
              echo "Removed $port for host $host"
              pkill -3 autossh
            else
              echo "Host / port not found"
            fi
          else
            echo "Error: /etc/tunnel not found"
            exit 1
          fi
          ;;
        host)
          checkargn $# 3
          host=$3

          if [ -z "$host" ]; then
            echo "Error: a host is required"
            echo "Usage: $BASENAME sshtunnel remove host <host>"
            exit 1
          elif ! echo $host | grep -q "[]@[]"; then
            echo "Error: invalid host"
            exit 1
          fi

          if [ -f /etc/tunnel ]; then
            counter=1
            while read -r line; do
              if [[ $line =~ "/usr/bin/autossh" ]]; then
                startline=$counter
              fi
              if [[ "$line" == "$host" ]]; then
                endline=$counter
                break
              fi
              ((counter++))
            done < <(cat /etc/tunnel)

            if [ -z $endline ]; then
              echo "Host not found in /etc/tunnel"
              exit 1
            fi

            sed -i "$startline, $endline d" /etc/tunnel
            echo "Removed $host from /etc/tunnel"
            pkill -3 autossh
          else
            echo "Error: /etc/tunnel not found"
            exit 1
          fi
          ;;
        *)
          echo "Error: unknown command"
          echo "Usage: $BASENAME sshtunnel remove <all | port | host>"
          exit 1
          ;;
      esac
      ;;
    list | "")
      checkargn $# 2
      host=$2

      if [ -f /etc/tunnel ]; then
        if [ ! -z "$host" ]; then
          if ! echo $host | grep -q "[]@[]"; then
            echo "Error: invalid host"
            exit 1
          fi

          newgroup=true
          declare -A ports
          while read -r -u 9 line; do
            if echo $line | grep -oPq "(?<=\-R )(.*?) "; then
              local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
              external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
              ports[$local]=$external
            elif echo $line | grep -q "[]@[]"; then
              if [[ "$line" == "$host" ]]; then
                echo "Ports:"
                echo "     local    ->   external"
                for i in "${!ports[@]}"; do
                  if [ "$newgroup" = true ]; then
                    printf "%10s %-6s %-6s %-5s\n" "┌─" "$i" "->" "${ports[$i]}"
                    newgroup=false
                  else
                    printf "%10s %-6s %-6s %-5s\n" "├─" "$i" "->" "${ports[$i]}"
                  fi
                done
                echo "    └─── Host: $line"
                break
              else
                unset ports
                declare -A ports
              fi
            fi
          done 9< /etc/tunnel
        else
          echo "Ports:"
          echo "     local    ->   external"
          newgroup=true
          while read -r -u 9 line; do
            if echo $line | grep -oPq "(?<=\-R )(.*?) "; then
              local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
              external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
              if [ "$newgroup" = true ]; then
                printf "%10s %-6s %-6s %-5s\n" "┌─" "$local" "->" "$external"
                newgroup=false
              else
                printf "%10s %-6s %-6s %-5s\n" "├─" "$local" "->" "$external"
              fi
            fi
            if echo $line | grep -q "[]@[]"; then
              echo "    └─── Host: $line"
              echo
              newgroup=true
            fi
          done 9< /etc/tunnel
        fi
      else
        echo "Error: a tunnel has not been set up yet"
        exit 1
      fi
      ;;
    check)
      checkargn $# 1
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
      checkargn $# 1
      if [ ! -f "/root/.ssh/id_rsa" ]; then
          ssh-keygen -q -N "" > "$LOGFILE" < /dev/zero
      fi
      cat /root/.ssh/id_rsa.pub
      ;;
    notice)
      case "$2" in
        on)
          checkargn $# 2
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
          checkargn $# 3
          value="$3"
          if [ -z "$value" ]; then
            echo "Error: You must specify a channel URL"
            exit 1
          fi

          echo "$value" >> /etc/tunnel_report_channels.txt
          echo "OK."
          ;;
        delete)
          checkargn $# 3
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
          checkargn $# 2
          if [ -f "/etc/tunnel_report_channels.txt" ]; then
            cat /etc/tunnel_report_channels.txt
          else
            echo "No channels found. No message send"
          fi
          ;;
        off)
          checkargn $# 2
          rm -rf /etc/tunnel_report.sh /etc/cron.d/tunnel_report /etc/tunnel_report_channels.txt || true
          echo "OK."
          ;;
        now)
          checkargn $# 2
          ports=()
          while read -r -u 9 line; do
            if [[ $line =~ "/usr/bin/autossh" ]]; then
              portinterval=$(echo $line | grep -oP "(?<=\-M )(.*?) ")
            elif echo $line | grep -q "[]@[]"; then
              host=$line
            fi

            if [ ! -z "$portinterval" ] && echo $line | grep -oPq "(?<=\-R )(.*?) "; then
              local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
              external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
              ports+=("$external:$local ")
            fi

            if [ ! -z "$portinterval" ] && [ ! -z "$host" ]; then
              message+="$host:$portinterval \\n"
              for i in "${ports[@]}"; do
                message+=$i
              done
              message+=" \\n"
              portinterval=""
              host=""
              ports=()
            fi

          done 9< /etc/tunnel
          
          message+="\`$(date -u +"%Y-%m-%d %H:%M:%S %Z")\` $(treehouses networkmode)"
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
          echo "Error: unknown command"
          echo "Usage: $BASENAME sshtunnel notice [on | add | delete | list | off | now]"
          exit 1
          ;;
      esac
      ;;
    *)
      echo "Error: unknown command"
      echo "Usage: $BASENAME sshtunnel [add | remove | list | check | key | notice]"
      exit 1
      ;;
  esac
}

function sshtunnel_help {
  echo
  echo "Usage: $BASENAME sshtunnel [add | remove | list | check | key | notice]"
  echo
  echo "Helps setting up sshtunnels to multiple hosts"
  echo
  echo "Host defaults to \"ole@pirate.ole.org\" if not explicitly provided"
  echo
  echo "Default list of ports when adding a host:"
  echo "  127.0.1.1:22   -> host:(port interval + 22)"
  echo "  127.0.1.1:5984 -> host:(port interval + 84)"
  echo "  127.0.1.1:80   -> host:(port interval + 80)"
  echo "  127.0.1.1:2200 -> host:(port interval + 82)"
  echo "  127.0.1.1:4949 -> host:(port interval + 49)"
  echo
  echo "  add                                      adds tunnels / ports to the given host"
  echo "      host <port interval> [host]              adds a new set of default tunnels"
  echo "      port <actual> <offset> [host]            adds a single port to an existing host"
  echo
  echo "  remove                                   removes tunnels / ports"
  echo "      all                                      completely removes all tunnels to all hosts"
  echo "      port <port> [host]                       removes a single port from an existing host"
  echo "      host <host>                              removes all tunnels from an existing host"
  echo
  echo "  list | \" \" [host]                      lists all existing tunnels to all hosts or the given host"
  echo
  echo "  check                                    runs a checklist of tests"
  echo
  echo "  key                                      shows the public key"
  echo
  echo "  notice                                   returns whether auto-reporting sshtunnel ports to gitter is on or off"
  echo "      on                                       turns on auto-reporting to gitter"
  echo "      add <value>                              adds a channel to report to"
  echo "      delete <value>                           deletes a channel to report to"
  echo "      list                                     lists all channels"
  echo "      off                                      turns off auto-reporting to gitter"
  echo "      now                                      immediately reports to gitter"
  echo
}
