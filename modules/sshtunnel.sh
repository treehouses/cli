#!/bin/bash

function sshtunnel {
  if { [ ! -f "/etc/tunnel" ] || [ ! -f "/etc/cron.d/autossh" ]; }  && [ "$1" != "add" ]; then
    logit "Error: no tunnel has been set up."
    logit "Run '$BASENAME sshtunnel add' to add a key for the tunnel."
    exit 0
  fi      
  portinterval="$2"
  host="$3"

  if [ -z "$host" ];
  then
    host="ole@pirate.ole.org"
  fi

  if [ -z "$1" ]; then
    "$1" ="list"
  fi

  hostname=$(echo "$host" | tr "@" \\n | sed -n 2p)

  if [ "$1" = "add" ]; then
    if [ -z "$portinterval" ];
    then
      log_and_exit1 "Error: A port interval is required"
    fi

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

    {
      echo "#!/bin/bash"
      echo
      echo "/usr/bin/autossh -f -T -N -q -4 -M$portinterval -R $portssh:127.0.1.1:22 -R $portcouchdb:127.0.1.1:5984 -R $portweb:127.0.1.1:80 -R $portnewcouchdb:127.0.1.1:2200 -R $portmunin:127.0.1.1:4949 $host"
    } > /etc/tunnel

    chmod +x /etc/tunnel

    if ! grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>"$LOGFILE"; then
      sed -i 's/^exit 0/if [ -f "\/etc\/tunnel" ];\nthen\n  \/etc\/tunnel\nfi\nexit 0/g' /etc/rc.local
    fi

    {
      echo "MAILTO=root"
      echo "*/5 * * * * root if [ ! "$\(pidof autossh\)" ]; then /etc/tunnel; fi"
    } > /etc/cron.d/autossh
  elif [ "$1" = "remove" ]; then
    if [ -f "/etc/tunnel" ]
    then
      rm -rf /etc/tunnel
    fi

    if [ -f "/etc/cron.d/autossh" ]
    then
      rm -rf /etc/cron.d/autossh
    fi

    pkill -3 autossh
    logit "${GREEN}Removed${NC}" "" "" "1"
  elif [ "$1" = "list" ]; then
    if [ -f "/etc/tunnel" ]; then
      portinterval=$(grep -oP "(?<=\-M)(.*?) " /etc/tunnel)
      portssh=$((portinterval + 22))
      portweb=$((portinterval + 80))
      portcouchdb=$((portinterval + 84))
      portnewcouchdb=$((portinterval + 82))
      portmunin=$((portinterval + 49))

      logit "Ports:"
      logit " local   -> external"
      logit "    22   -> $portssh"
      logit "    80   -> $portweb"
      logit "    2200 -> $portnewcouchdb"
      logit "    4949 -> $portmunin"
      logit "    5984 -> $portcouchdb"
      logit "Host: $(sed -r "s/.* (.*?)$/\1/g" /etc/tunnel | tail -n1)"
    else
      log_and_exit1 "Error: a tunnel has not been set up yet"
    fi
  elif [ "$1" = "check" ]; then
    if [ -f "/etc/tunnel" ]; then
      logit "[${GREEN}OK${NC}] /etc/tunnel" "" "" "1"
    else
      logit "[${RED}MISSING${NC}] /etc/tunnel" "" "" "1"
    fi

    if [ -f "/etc/cron.d/autossh" ]
    then
      logit "[${GREEN}OK${NC}] /etc/cron.d/autossh" "" "" "1"
    else
      logit "[${RED}MISSING${NC}] /etc/cron.d/autossh" "" "" "1"
    fi

    if grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>"$LOGFILE"; then
      logit "[${GREEN}OK${NC}] /etc/rc.local starts /etc/tunnel if exists" "" "" "1"
    else
      logit "[${RED}MISSING${NC}] /etc/rc.local doesn't start /etc/tunnel if exists" "" "" "1"
    fi

    if [ "$(pidof autossh)" ]
    then
      logit "[${GREEN}OK${NC}] autossh pid: $(pidof autossh)" "" "" "1"
    else
      logit "[${RED}MISSING${NC}] autossh not running" "" "" "1"
    fi
  elif [ "$1" = "key" ]; then
    if [ ! -f "/root/.ssh/id_rsa" ]; then
        ssh-keygen -q -N "" > "$LOGFILE" < /dev/zero
    fi
    cat /root/.ssh/id_rsa.pub
  elif [ "$1" = "notice" ]; then
    option="$2"
    if [ "$option" = "on" ]; then
      cp "$TEMPLATES/network/tunnel_report.sh" /etc/tunnel_report.sh
      if [ ! -f "/etc/cron.d/tunnel_report" ]; then
        echo "*/1 * * * * root if [ -f \"/etc/tunnel\" ]; then /etc/tunnel_report.sh; fi" > /etc/cron.d/tunnel_report
      fi
      if [ ! -f "/etc/tunnel_report_channels.txt" ]; then
        echo "https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages" >> /etc/tunnel_report_channels.txt
      fi
      logit "OK."
    elif [ "$option" = "add" ]; then
      value="$3"
      if [ -z "$value" ]; then
        log_and_exit1 "Error: You must specify a channel URL"
      fi

      echo "$value" >> /etc/tunnel_report_channels.txt
      logit "OK."
    elif [ "$option" = "delete" ]; then
      value="$3"
      if [ -z "$value" ]; then
        log_and_exit1 "Error: You must specify a channel URL"
      fi

      value=$(echo $value | sed 's/\//\\\//g')
      sed -i "/^$value/d" /etc/tunnel_report_channels.txt
      logit "OK."
    elif [ "$option" = "list" ]; then
      if [ -f "/etc/tunnel_report_channels.txt" ]; then
        cat /etc/tunnel_report_channels.txt
      else
        logit "No channels found. No message send"
      fi
    elif [ "$option" = "off" ]; then
      rm -rf /etc/tunnel_report.sh /etc/cron.d/tunnel_report /etc/tunnel_report_channels.txt || true
      logit "OK."
    elif [ "$option" = "now" ]; then
      portinterval=$(grep -oP "(?<=\-M)(.*?) " /etc/tunnel)
      portssh=$((portinterval + 22))
      portweb=$((portinterval + 80))
      portcouchdb=$((portinterval + 84))
      portnewcouchdb=$((portinterval + 82))
      portmunin=$((portinterval + 49))
      treehouses feedback "$(sed -r "s/.* (.*?)$/\1/g" /etc/tunnel | tail -n1):$portinterval\n$portssh:22 $portweb:80 $portnewcouchdb:2200 $portmunin:4949 $portcouchdb:5984\n\`$(date -u +"%Y-%m-%d %H:%M:%S %Z")\` $(treehouses networkmode)"
    elif [ -z "$option" ]; then
      if [ -f "/etc/cron.d/tunnel_report" ]; then
        status="on"
      else
        status="off"
      fi
      logit "Status: $status"
    else
      logit "Error: only 'on' and 'off' options are supported."
    fi
  else
    log_and_exit1 "Error: only 'add', 'remove', 'list', 'check', 'key', 'notice' options are supported";
  fi
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
