function sshtunnel {
  local portinterval host hostname portssh portweb portcouchdb
  local portnewcouchdb portmunin keys option value status tag profile
  checkroot

  if { [ ! -f "/etc/tunnel" ] || [ ! -f "/etc/cron.d/autossh" ]; } && [[ ! "$*" =~ "add host" ]] && [[ ! "$*" =~ "remove all" ]] && [[ ! "$*" =~ "check" ]] && [[ ! "$*" =~ "key" ]]; then
    log_comment_and_exit1 "Error: no tunnel has been set up" "Run '$BASENAME sshtunnel add host <port interval> [host]' to add a key for the tunnel"
  fi

  re='^[0-9]+$'
  sshkeyname=`treehouses config | grep keyName | sed "s/keyName=//"`
  if [ -z "$sshkeyname" ]; then
    SSHKeyName="rsa_id"
  fi

  case "$1" in
    add)
      case "$2" in
        host)
          checkargn $# 4
          portinterval=$3
          host=$4

          if [ -z "$portinterval" ] || [[ ! $portinterval =~ $re ]]; then
            log_comment_and_exit1 "Error: a numeric port interval is required" "Usage: $BASENAME sshtunnel add host <port interval> [host]"
          fi

          # host validation
          if [ -z "$host" ]; then
            host="ole@pirate.ole.org"
          elif ! echo $host | grep -q "[]@[]"; then
            log_comment_and_exit1 "Error: invalid host" "user@host"
          fi
          hostname=$(echo "$host" | tr "@" \\n | sed -n 2p)

          # check if host already exists
          if grep -qs "$host" /etc/tunnel; then
            log_comment_and_exit1 "Error: host already exists" "Try adding individual ports to the host or adding a different host"
          fi

          # check if monitoring port already in use
          portint_offset=0
          while grep -qs -e "M $((portinterval - 1))" -e "M $portinterval" -e "M $((portinterval + 1))" /etc/tunnel; do
            portinterval=$((portinterval + 1))
            portint_offset=$((portint_offset + 1))
          done

          # default list of ports
          portssh=$((portinterval + 22 - portint_offset))
          portweb=$((portinterval + 80 - portint_offset))
          portnewcouchdb=$((portinterval + 82 - portint_offset))

          if [ ! -f "/root/.ssh/$sshkeyname" ]; then
            ssh-keygen -q -N "" > "$LOGFILE" < /dev/zero
          fi
          cat /root/.ssh/$sshkeyname.pub
          echo "Port successfully added"

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
            echo "-R $portweb:127.0.1.1:80 \\"
            echo "-R $portnewcouchdb:127.0.1.1:2200 \\"
            echo "$host # $((portinterval - portint_offset))"
          } >> /etc/tunnel
          chmod +x /etc/tunnel

          if ! grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>"$LOGFILE"; then
            sed -i 's/^exit 0/if [ -f "\/etc\/tunnel" ];\nthen\n  \/etc\/tunnel\nfi\nexit 0/g' /etc/rc.local
          fi

          {
            echo "MAILTO=root"
            echo "*/5 * * * * root if [ ! "$\(pidof autossh\)" ]; then /etc/tunnel; fi"
          } > /etc/cron.d/autossh

          if [ -f "/etc/cron.d/tunnel_report" ]; then
            sshtunnel notice now > /dev/null
          fi
          ;;
        port)
          case "$3" in
            offset)
              checkargn $# 6
              actual=$4
              offset=$5
              host=$6

              if [ -z "$actual" ] || [[ ! $actual =~ $re ]]; then
                log_comment_and_exit1 "Error: a numeric port is required" "Usage: $BASENAME sshtunnel add port offset <actual> <offset> [host]"
              elif [ -z "$offset" ] || [[ ! $offset =~ $re ]]; then
                log_comment_and_exit1 "Error: a numeric offset is required" "Usage: $BASENAME sshtunnel add port offset <actual> <offset> [host]"
              elif [ "$offset" -ge 100 ]; then
                log_comment_and_exit1 "Error: offset is greater than or equal to 100" "Use an offset less than 100 (save some ports for others!)"
              fi

              # host validation
              if [ -z "$host" ]; then
                host="ole@pirate.ole.org"
              elif ! echo $host | grep -q "[]@[]"; then
                log_comment_and_exit1 "Error: invalid host" "user@host"
              fi

              # get port interval for given host
              portinterval=$(grep $host /etc/tunnel | awk '{print $3}')

              if [ ! -z "$portinterval" ]; then
                # check if port is already added
                found=false
                while read -r line; do
                  if [[ $line =~ 127.0.1.1:$actual ]]; then
                    exists=yes
                  fi
                  if [ ! -z "$exists" ] && [[ $line = *$host* ]]; then
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
                  # find monitoring port
                  while read -r line; do
                    if [[ $line =~ "/usr/bin/autossh" ]]; then
                      monitoringport=$(echo $line | grep -oP "(?<=\-M )(.*?) ")
                    fi
                    if [ ! -z "$monitoringport" ] && [[ $line = *$host* ]]; then
                      break
                    fi
                  done < <(cat /etc/tunnel)

                  if [ "$monitoringport" -eq "$((portinterval + offset))" ] || [ "$((monitoringport + 1))" -eq "$((portinterval + offset))" ]; then
                    echo "Error: port conflict with monitoring port"
                    echo "Trying to add $((portinterval + offset)) which conflicts with monitoring port $monitoringport"
                    echo "Monitoring ports ${monitoringport::-1} and $((monitoringport + 1)) must be clear"
                  else
                    sed -i "/^$host/i -R $((portinterval + offset)):127.0.1.1:$actual \\\\" /etc/tunnel
                    echo "Added $actual -> $((portinterval + offset)) for host $host"
                    if [ -f "/etc/cron.d/tunnel_report" ]; then
                      sshtunnel notice now > /dev/null 
                    fi
                    sshtunnel_kill $host
                  fi
                fi
              else
                echo "Host not found"
              fi
              ;;
            actual)
              checkargn $# 6
              actual=$4
              port=$5
              host=$6

              if [ -z "$actual" ] || [[ ! $actual =~ $re ]]; then
                log_comment_and_exit1 "Error: a numeric port is required" "Usage: $BASENAME sshtunnel add port actual <actual> <port> [host]"
              elif [ -z "$port" ] || [[ ! $port =~ $re ]]; then
                log_comment_and_exit1 "Error: a numeric port is required" "Usage: $BASENAME sshtunnel add port actual <actual> <port> [host]"
              fi

              # host validation
              if [ -z "$host" ]; then
                host="ole@pirate.ole.org"
              elif ! echo $host | grep -q "[]@[]"; then
                log_comment_and_exit1 "Error: invalid host" "user@host"
              fi

              # if host exists
              if grep -q "$host" /etc/tunnel; then
                # check if port is already added
                found=false
                while read -r line; do
                  if [[ $line =~ $port:127.0.1.1:$actual ]]; then
                    exists=yes
                  fi
                  if [ ! -z "$exists" ] && [[ $line = *$host* ]]; then
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
                  # find monitoring port 
                  while read -r line; do
                    if [[ $line =~ "/usr/bin/autossh" ]]; then
                      monitoringport=$(echo $line | grep -oP "(?<=\-M )(.*?) ")
                    fi
                    if [ ! -z "$monitoringport" ] && [[ $line = *$host* ]]; then
                      break
                    fi
                  done < <(cat /etc/tunnel)

                  if [ "$monitoringport" -eq "$port" ] || [ "$((monitoringport + 1))" -eq "$port" ]; then
                    echo "Error: port conflict with monitoring port"
                    echo "Trying to add $port which conflicts with monitoring port $monitoringport"
                    echo "Monitoring ports ${monitoringport::-1} and $((monitoringport + 1)) must be clear"
                  else
                    sed -i "/^$host/i -R $port:127.0.1.1:$actual \\\\" /etc/tunnel
                    echo "Added $actual -> $port for host $host"

                    if [ -f "/etc/cron.d/tunnel_report" ]; then
                      sshtunnel notice now > /dev/null 
                    fi
                    
                    sshtunnel_kill $host
                  fi
                fi
              else
                echo "Host not found"
              fi
              ;;
            *)
              log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel add port <offset | actual>"
              ;;
          esac
          ;;
        *)
          log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel add <host | port>"
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

          pkill autossh
          echo -e "${GREEN}Removed${NC}"
          ;;
        port)
          checkargn $# 4
          port=$3
          host=$4

          if [ -z "$port" ]; then
            log_comment_and_exit1 "Error: a port is required" "Usage: $BASENAME sshtunnel remove port <port> [host]"
          fi

          # host validation
          if [ -z "$host" ]; then
            host="ole@pirate.ole.org"
          elif ! echo $host | grep -q "[]@[]"; then
            log_comment_and_exit1 "Error: invalid host" "user@host"
          fi

          counter=1
          found=false
          while read -r line; do
            if [[ $line = *"-R $port:127.0.1.1"* ]]; then
              final=$counter
            fi
            if [ ! -z "$final" ] && [[ $line = *$host* ]]; then
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
            if [ -f "/etc/cron.d/tunnel_report" ]; then
              sshtunnel notice now > /dev/null
            fi
            sshtunnel_kill $host
          else
            echo "Host / port not found"
          fi
          ;;
        host)
          checkargn $# 3
          host=$3

          if [ -z "$host" ]; then
            log_comment_and_exit1 "Error: a host is required" "Usage: $BASENAME sshtunnel remove host <host>"
          elif ! echo $host | grep -q "[]@[]"; then
            log_comment_and_exit1 "Error: invalid host" "user@host"
          fi

          counter=1
          while read -r line; do
            if [[ $line =~ "/usr/bin/autossh" ]]; then
              startline=$counter
            fi
            if [[ $line = *$host* ]]; then
              endline=$counter
              break
            fi
            ((counter++))
          done < <(cat /etc/tunnel)

          if [ -z $endline ]; then
            log_and_exit1 "Host not found in /etc/tunnel"
          fi

          sed -i "$((startline - 1)), $endline d" /etc/tunnel
          echo "Removed $host from /etc/tunnel"
          if [ -f "/etc/cron.d/tunnel_report" ]; then
            sshtunnel notice now > /dev/null
          fi
          sshtunnel_kill $host
          ;;
        *)
          log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel remove <all | port | host>"
          ;;
      esac
      ;;
    refresh)
      checkargn $# 2
      host=$2

      if [ -z "$host" ]; then
        count=$(pgrep -c autossh)
        screen -dm bash -c "pkill autossh ; bash /etc/tunnel"
        echo "Refreshed tunnels to $count host(s)"
      else
        pid=$(pgrep -a "autossh" | grep "$host$" | awk '{print $1}')
        if [ ! -z "$pid" ]; then
          screen -dm bash -c "kill -- -$pid ; bash /etc/tunnel"
          echo "Refreshed tunnels to $host"
        else
          echo "No tunnels to $host active"
        fi
      fi
      ;;
    list | "")
      checkargn $# 2
      host=$2

      if [ ! -z "$host" ]; then
        if ! echo $host | grep -q "[]@[]"; then
          log_comment_and_exit1 "Error: invalid host" "user@host"
        fi

        newgroup=true
        declare -A ports
        while read -r -u 9 line; do
          if echo $line | grep -oPq "(?<=\-R )(.*?) "; then
            local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
            external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
            ports[$local]=$external
          elif echo $line | grep -q "[]@[]"; then
            if [[ $line = *$host* ]]; then
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
              echo
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
      ;;
    active)
      checkargn $# 1
      echo "Active tunnels:"
      pgrep -a "ssh" | grep "/usr/bin/ssh" | while read -r line; do
        host=$(echo $line | awk '{print $NF}')
        tunnels=$(echo $line | grep -o "\-R" | wc -l)
        echo "  - $host, $((tunnels - 1)) active ports"
      done
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
      case "$2" in
        "")
          if [ ! -f "/root/.ssh/$SSHKeyName" ]; then
              ssh-keygen -q -N "" > "$LOGFILE" < /dev/zero
          fi
          cat /root/.ssh/$SSHKeyName.pub
          ;;
        verify)
          checkargn $# 2
          if [ -f "/root/.ssh/$SSHKeyName" ] && [ -f "/root/.ssh/$SSHKeyName.pub" ]; then
            verify=$(diff <( ssh-keygen -y -e -f "/root/.ssh/$SSHKeyName" ) <( ssh-keygen -y -e -f "/root/.ssh/$SSHKeyName.pub" ))
            if [ "$verify" != "" ]; then
              echo -e "Public and private rsa keys ${RED}do not match${NC}"
            else
              echo -e "Public and private rsa keys ${GREEN}match${NC}"
            fi
          else
            echo "Missing public / private rsa keys"
          fi
          ;;
        send)
          checkargn $# 4
          profile=$4

          if [[ $profile == "default" ]]; then
            profile=""
          elif [ ! -z "$profile" ]; then
            profile="_${profile}"
          fi

          case "$3" in
            public | private)
              if [ "$3" = "public" ]; then
                tag=".pub"
              fi

              if [ -f /root/.ssh/${SSHKeyName}${profile}${tag} ]; then
                cat /root/.ssh/${SSHKeyName}${profile}${tag}
              else
                log_and_exit1 "No $3 key found"
              fi
              ;;
            *)
              log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel key send <public | private> [profile]"
              ;;
          esac
          ;;
        receive)
          checkargn $# 5
          key=$4
          profile=$5

          if [[ $profile == "default" ]]; then
            profile=""
          elif [ ! -z "$profile" ]; then
            profile="_${profile}"
          fi

          case "$3" in
            public | private)
              if [ "$3" = "public" ]; then
                tag=".pub"
              fi

              if [ -f /root/.ssh/${SSHKeyName}${profile}${tag} ]; then
                timestamp=$(date +%Y%m%d%H%M)
                mv "/root/.ssh/${SSHKeyName}${profile}${tag}" "/root/.ssh/${SSHKeyName}${profile}.${timestamp}${tag}"
                echo "Created backup of '${SSHKeyName}${profile}${tag}' as '${SSHKeyName}${profile}.${timestamp}${tag}'"
              fi

              echo -e "$key" > "/root/.ssh/${SSHKeyName}${profile}${tag}"
              echo "Saved $3 key to '${SSHKeyName}${profile}${tag}'"
              ;;
            *)
              log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel key receive <public | private> <\$key> [profile]"
              ;;
          esac
          ;;
  	name)
	  case "$3" in
	    "")
	      echo "Current SSH key name: $SSHKeyName"
	      ;;
	    *)
	      treehouses config update keyName "$3"
	      echo "Set the SSH key name to: $3"
	      ;;
	    esac
	  ;;
  	*)
          log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel key [verify | send | receive]"
          ;;
      esac
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
            log_and_exit1 "Error: You must specify a channel URL"
          fi

          echo "$value" >> /etc/tunnel_report_channels.txt
          echo "OK."
          ;;
        delete)
          checkargn $# 3
          value="$3"
          if [ -z "$value" ]; then
            log_and_exit1 "Error: You must specify a channel URL"
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
          notice_ports=()
          while read -r -u 9 line; do
            if [[ $line =~ "/usr/bin/autossh" ]]; then
              monitoringport=$(echo $line | grep -oP "(?<=\-M )(.*?) ")
            elif echo $line | grep -q "[]@[]"; then
              host=$(echo $line | awk '{print $1}')
            fi

            if [ ! -z "$monitoringport" ] && echo $line | grep -oPq "(?<=\-R )(.*?) "; then
              local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
              external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
              notice_ports+=("$external:$local ")
            fi

            if [ ! -z "$monitoringport" ] && [ ! -z "$host" ]; then
              message+="$host:$monitoringport \\n"
              for i in "${notice_ports[@]}"; do
                message+=$i
              done
              message+=" \\n"
              monitoringport=""
              host=""
              notice_ports=()
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
          log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel notice [on | add | delete | list | off | now]"
          ;;
      esac
      ;;
    ports)
      checkargn $# 1
      message_ports=()
      while read -r line; do
        if [[ $line =~ "/usr/bin/autossh" ]]; then
          monitoringport=$(echo $line | grep -oP "(?<=\-M )(.*?) ")
        elif echo $line | grep -q "[]@[]"; then
          host=$(echo $line | awk '{print $1}')
        fi

        if [ ! -z "$monitoringport" ] && echo $line | grep -oPq "(?<=\-R )(.*?) "; then
          local=$(echo $line | grep -oP '(?<=127.0.1.1:).*?(?= )')
          external=$(echo $line | grep -oP '(?<=-R ).*?(?=:127)')
          notice_ports+=("$external:$local ")
        fi

        if [ ! -z "$monitoringport" ] && [ ! -z "$host" ]; then
          message+="$host:$monitoringport"
          for i in "${notice_ports[@]}"; do
            message+=$i
          done
          message+="\n"
          monitoringport=""
          host=""
          notice_ports=()
        fi
      done < /etc/tunnel

      echo -e ${message::-3}
      ;;
    *)
      log_comment_and_exit1 "Error: unknown command" "Usage: $BASENAME sshtunnel [add|remove|refresh|list|active|check|key|notice|ports]"
      ;;
  esac
}

function sshtunnel_kill {
  host=$1

  pid=$(pgrep -a "autossh" | grep "$host" | awk '{print $1}')
  if [ ! -z "$pid" ]; then
    screen -dm bash -c "kill -- -$pid ; bash /etc/tunnel"
  fi
}

function sshtunnel_help {
  echo
  echo "Usage: $BASENAME sshtunnel [add|remove|refresh|list|active|check|key|notice|ports]"
  echo
  echo "Helps setting up sshtunnels to multiple hosts"
  echo
  echo "Host defaults to \"ole@pirate.ole.org\" if not explicitly provided"
  echo
  echo "Monitoring port and monitoring port + 1 must be kept clear"
  echo "If there are monitoring port conflicts while adding new hosts,"
  echo "monitoring port will be incremented by 2 and adding host will be reattempted."
  echo
  echo "Default list of ports when adding a host:"
  echo "  127.0.1.1:22   -> host:(port interval + 22)"
  echo "  127.0.1.1:80   -> host:(port interval + 80)"
  echo "  127.0.1.1:2200 -> host:(port interval + 82)"
  echo
  echo "  add                                      adds tunnels / ports to the given host"
  echo "      host <port interval> [host]              adds a new set of default tunnels"
  echo "      port                                     adds a single port to an existing host"
  echo "          offset <actual> <offset> [host]          uses port interval + offset to calculate the new port"
  echo "          actual <actual> <port> [host]            adds a port directly instead of using offsets"
  echo
  echo "  remove                                   removes tunnels / ports"
  echo "      all                                      completely removes all tunnels to all hosts"
  echo "      port <port> [host]                       removes a single port from an existing host"
  echo "      host <host>                              removes all tunnels from an existing host"
  echo
  echo "  refresh                                  kills and restarts tunnels to all hosts"
  echo "      [host]                                   kills and restarts tunnels to given host"
  echo
  echo "  \" \" | list                               lists all existing tunnels to all hosts"
  echo "      [host]                                   lists existing tunnels to given host"
  echo
  echo "  active                                   lists active ssh tunnels"
  echo
  echo "  check                                    runs a checklist of tests"
  echo
  echo "  key                                      shows the public key"
  echo "      [name] [sshkeyfile]                              sets default SSH key to desired filename"
  echo "      [verify]                                         verifies that the public and private rsa keys match"
  echo "      [send] <public | private> [profile]              sends public / private key"
  echo "      [receive] <public | private> <\$key> [profile]    saves \$key as public / private key"
  echo
  echo "  notice                                   returns whether auto-reporting sshtunnel ports to gitter is on or off"
  echo "      on                                       turns on auto-reporting to gitter"
  echo "      add <value>                              adds a channel to report to"
  echo "      delete <value>                           deletes a channel to report to"
  echo "      list                                     lists all channels"
  echo "      off                                      turns off auto-reporting to gitter"
  echo "      now                                      immediately reports to gitter"
  echo
  echo "  ports                                    lists all existing tunnels to all hosts in a single string"
  echo
  echo "Adding a port using offsets:"
  echo "  To add local port 100 with an offset of 200, run"
  echo "      '$BASENAME sshtunnel add port offset 100 200 [host]'"
  echo
  echo "  The script will add an offset of 200 to the port interval for [host] and insert"
  echo "  into /etc/tunnel"
  echo "      '-R (port interval + 200):127.0.1.1:100 \\'"
  echo
  echo "  Resulting in"
  echo "      Ports:"
  echo "           local    ->   external"
  echo "          ┌─ 100    ->     port interval + 200"
  echo "          └─── Host: user@host # port interval"
  echo
  echo "Adding a port directly:"
  echo "  To add local port 100 with external port 20000, run"
  echo "      '$BASENAME sshtunnel add port actual 100 20000 [host]'"
  echo
  echo "  The script will directly insert into /etc/tunnel"
  echo "      '-R 20000:127.0.1.1:100 \\'"
  echo
  echo "  Resulting in"
  echo "      Ports:"
  echo "           local    ->   external"
  echo "          ┌─ 100    ->     20000"
  echo "          └─── Host: user@host # port interval"
  echo
  echo "Removing a port:"
  echo "  Ports to be removed are specified by their external port"
  echo "      Ports:"
  echo "           local    ->   external"
  echo "          ┌─ 22     ->     20022"
  echo "          ├─ 80     ->     20080"
  echo "     ┌──> ├─ 2200   ->     20082"
  echo "     │    └─── Host: user@host # port interval"
  echo "     │"
  echo "     └── to remove this port, run"
  echo "      '$BASENAME sshtunnel remove port 20082 host'"
  echo
  echo "  Resulting in"
  echo "      Ports:"
  echo "           local    ->   external"
  echo "          ┌─ 22     ->     20022"
  echo "          ├─ 80     ->     20080"
  echo "          └─── Host: user@host # port interval"
  echo
  echo "Adding a host:"
  echo "  To add a host with port interval 12345, run"
  echo "      '$BASENAME sshtunnel add host 12345 [host]'"
  echo
  echo "  This will add the default list of ports starting from port interval 12345"
  echo
  echo "  Resulting in"
  echo "      Ports:"
  echo "           local    ->   external"
  echo "          ┌─ 22     ->     12367"
  echo "          ├─ 80     ->     12425"
  echo "          ├─ 2200   ->     12427"
  echo "          └─── Host: user@host # 12345"
  echo
  echo "  If the monitoring port or monitoring port + 1 is currently in use by any other host,"
  echo "  the monitoring port will be incremented by 1 until the two ports are clear."
  echo
  echo "Removing a host"
  echo "  To remove a host, run"
  echo "      '$BASENAME sshtunnel remove host <host>'"
  echo
  echo "  This will remove all current ports to the given host"
  echo
}
