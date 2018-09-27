#!/bin/bash

function sshtunnel {
  action="$1"
  portinterval="$2"
  host="$3"

  if [ -z "$host" ];
  then
    host="ole@pirate.ole.org"
  fi

  hostname=$(echo "$host" | tr "@" \\n | sed -n 2p)

  if [ "$action" = "add" ]; then
    if [ -z "$portinterval" ];
    then
      echo "Error: A port interval is required"
      exit 1
    fi

    portssh=$((portinterval + 22))
    portweb=$((portinterval + 80))
    portcouchdb=$((portinterval + 84))
    portnewcouchdb=$((portinterval + 82))
    portmunin=$((portinterval + 49))

    if [ ! -f "/root/.ssh/id_rsa" ]; then
      ssh-keygen -q -N "" > /dev/null < /dev/zero
    fi

    cat /root/.ssh/id_rsa.pub

    keys=$(ssh-keyscan -H "$hostname" 2>/dev/null)
    while read -r key; do
      if ! grep -q "$key" /root/.ssh/known_hosts 2>/dev/null; then
          echo "$key" >> /root/.ssh/known_hosts
      fi
    done <<< "$keys"

    {
      echo "#!/bin/bash"
      echo
      echo "/usr/bin/autossh -f -T -N -q -4 -M$portinterval -R $portssh:127.0.1.1:22 -R $portcouchdb:127.0.1.1:5984 -R $portweb:127.0.1.1:80 -R $portnewcouchdb:127.0.1.1:2200 -R $portmunin:127.0.1.1:4949 $host"
    } > /etc/tunnel

    chmod +x /etc/tunnel

    if ! grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>/dev/null; then
      sed -i 's/^exit 0/if [ -f "\/etc\/tunnel" ];\nthen\n  \/etc\/tunnel\nfi\nexit 0/g' /etc/rc.local
    fi

    {
      echo "MAILTO=root"
      echo "*/5 * * * * root if [ ! "$\(pidof autossh\)" ]; then /etc/tunnel; fi"
    } > /etc/cron.d/autossh
  elif [ "$action" = "remove" ]; then
    if [ -f "/etc/tunnel" ]
    then
      rm -rf /etc/tunnel
    fi

    if [ -f "/etc/cron.d/autossh" ]
    then
      rm -rf /etc/cron.d/autossh
    fi

    pkill -3 autossh
    echo -e "${GREEN}Removed${NC}"
  elif [ "$action" = "show" ]; then
    if [ -f "/etc/tunnel" ]; then
      echo -e "[${GREEN}OK${NC}] /etc/tunnel"
    else
      echo -e "[${RED}MISSING${NC}] /etc/tunnel"
    fi

    if [ -f "/etc/cron.d/autossh" ]
    then
      echo -e "[${GREEN}OK${NC}] /etc/cron.d/autossh"
    else
      echo -e "[${RED}MISSING${NC}] /etc/cron.d/autossh"
    fi

    if grep -q "\\-f \"/etc/tunnel\"" /etc/rc.local 2>/dev/null; then
      echo -e "[${GREEN}OK${NC}] /etc/rc.local starts /etc/tunnel if exists"
    else
      echo -e "[${RED}MISSING${NC}] /etc/rc.local doesn't start /etc/tunnel if exists"
    fi

    if [ "$(pidof autossh)" ]
    then
      echo -e "[${GREEN}OK${NC}] autossh pid: $(pidof autossh)"
    else
      echo -e "[${RED}MISSING${NC}] autossh not running"
    fi
  elif [ "$action" = "key" ]; then
    if [ ! -f "/root/.ssh/id_rsa" ]; then
        ssh-keygen -q -N "" > /dev/null < /dev/zero
    fi
    cat /root/.ssh/id_rsa.pub
  elif [ "$action" = "notice" ]; then
    option="$2"
    if [ "$option" == "on" ]; then
      cp "$TEMPLATES/network/tunnel_report.sh" /etc/tunnel_report.sh
      if [ -f "/etc/cron.d/tunnel_report" ]; then
        echo "*/5 * * * * root if [ ! "$\(pidof autossh\)" ]; then /etc/tunnel_report.sh; fi" > /etc/cron.d/tunnel_report
      fi
      echo "OK."
    elif [ "$option" == "off" ]; then
      rm -rf /etc/tunnel_report.sh /etc/cron.d/tunnel_report || true
      echo "OK."
    else
      echo "Error: only 'on' and 'off' options are supported."
    fi
  else
    echo "Error: only 'add', 'remove', 'show', 'key', 'notice' options are supported";
    exit 1
  fi
}

function sshtunnel_help {
  echo ""
  echo "Usage: $(basename "$0") sshtunnel <add|remove|show|key> <portinterval> [user@host]"
  echo ""
  echo "Helps setting up a sshtunnel"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") sshtunnel add 65400 user@server.org"
  echo "      This will set up autossh with the host 'user@server.org' and open the following tunnels"
  echo "      127.0.1.1:22 -> host:65422"
  echo "      127.0.1.1:49 -> host:65449"
  echo "      127.0.1.1:80 -> host:65480"
  echo "      127.0.1.1:2200 -> host:65482"
  echo "      127.0.1.1:5984 -> host:65484"
  echo ""
  echo "  $(basename "$0") sshtunnel remove"
  echo "      This will stop the ssh tunnels and remove the extra files added"
  echo ""
  echo "  $(basename "$0") sshtunnel show"
  echo "      This will run a checklist and report back the results."
  echo ""
  echo "  $(basename "$0") sshtunnel key"
  echo "      This will show the public key."
  echo ""
}
