#!/bin/bash

function tor {
  check_missing_packages "tor" "curl"

  if { [ ! -d "/var/lib/tor/treehouses" ] || [ ! -f "/var/lib/tor/treehouses/hostname" ]; } && [ "$1" != "start" ] && [ "$1" != "add" ]; then
    if [ -z "$(grep -Poi "^HiddenServicePort \\K(.*) 127.0.0.1:(.*)\\b" /etc/tor/torrc | tac | sed -r 's/(.*?)127.0.0.1:(.*?)/\1 <=> \2/g')" ]; then
      echo "Error: there are no tor ports added."
      echo "'$BASENAME add [localPort]' to add a port and be able to use the service"
    else
      echo "Error: the tor service has not been configured."
      echo "Run '$BASENAME tor start' to configure it."
    fi
    exit 1
  fi

  if [ -z "$1" ]; then
    cat "/var/lib/tor/treehouses/hostname"
    exit 0
  fi

  if [ "$1" = "list" ]; then
    echo "external <=> local"
    grep -Poi "^HiddenServicePort \\K(.*) 127.0.0.1:(.*)\\b" /etc/tor/torrc | tac | sed -r 's/(.*?)127.0.0.1:(.*?)/\1 <=> \2/g'
  elif [ "$1" = "add" ]; then
    if ! grep -Pq "^HiddenServiceDir .*" "/etc/tor/torrc"; then
      echo "HiddenServiceDir /var/lib/tor/treehouses" >> /etc/tor/torrc
    fi

    port="$2"
    local_port="$3"

    if [ -z "$port" ]; then
      echo "Error: you must specify a port"
      exit 1
    fi

    if  ! [[ "$port" =~ ^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$ ]]; then
      echo "Error: is not a port"
      exit 1
    fi

    if [ -z "$local_port" ]; then
      local_port="$port"
    fi

    if  ! [[ "$local_port" =~ ^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$ ]]; then
      echo "Error: is not a port"
      exit 1
    fi

    existing_port=$(grep -Poi "^HiddenServicePort $port .*" /etc/tor/torrc)
    if [ ! -z "$existing_port" ]; then
      sed -i "s/$existing_port/HiddenServicePort $port 127.0.0.1:$local_port/g" /etc/tor/torrc
    else
      echo "HiddenServicePort $port 127.0.0.1:$local_port " >> /etc/tor/torrc
    fi

    restart_service tor
    echo "Success: the port has been added"
  elif [ "$1" = "delete" ]; then
    if [ -z "$2" ]; then
      echo "Error: no port entered"
      exit 1
    fi

    if  ! [[ "$2" =~ ^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$ ]]; then
      echo "Error: $2 is not a port"
      exit 1
    fi

    if ! grep -wq "HiddenServicePort $2" /etc/tor/torrc ; then
      echo "Port $2 is not assigned"
      exit 0
    fi

    sed -i "/^HiddenServicePort $2 /d" /etc/tor/torrc
    restart_service tor
    echo "Port $2 has been deleted"
  elif [ "$1" = "deleteall" ]; then
    if [ -n "$2" ]; then
      echo "Error: wrong synthax"
      exit 1
    fi

    sed -i "/^HiddenServicePort /d" /etc/tor/torrc
    restart_service tor
    echo "All ports have been deleted"
  elif [ "$1" = "stop" ]; then
    stop_service tor
    echo "Success: the tor service has been stopped"
  elif [ "$1" = "start" ]; then
    if [ ! -d "/var/lib/tor/treehouses" ]; then
      mkdir "/var/lib/tor/treehouses"
      chown debian-tor:debian-tor /var/lib/tor/treehouses
      chmod 700 /var/lib/tor/treehouses
    fi

    if ! grep -Pq "^HiddenServiceDir .*" "/etc/tor/torrc"; then
      echo "HiddenServiceDir /var/lib/tor/treehouses" >> /etc/tor/torrc
    fi

    start_service tor
    echo "Success: the tor service has been started"
  elif [ "$1" = "destroy" ]; then
    stop_service tor
    echo > /etc/tor/torrc
    rm -rf /var/lib/tor/treehouses

    echo "Success: the tor service has been destroyed"
  elif [ "$1" = "notice" ]; then
    option="$2"
    if [ "$option" = "on" ]; then
      cp "$TEMPLATES/network/tor_report.sh" /etc/tor_report.sh
      if [ ! -f "/etc/cron.d/tor_report" ]; then
        echo "*/1 * * * * root if [ -d \"/var/lib/tor/treehouses\" ]; then /etc/tor_report.sh; fi" > /etc/cron.d/tor_report
      fi
      if [ ! -f "/etc/tor_report_channels.txt" ]; then
        echo "https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages" >> /etc/tor_report_channels.txt
      fi
      echo "OK."
    elif [ "$option" = "add" ]; then
      value="$3"
      if [ -z "$value" ]; then
        echo "Error: You must specify a channel URL"
        exit 1
      fi

      echo "$value" >> /etc/tor_report_channels.txt
      echo "OK."
    elif [ "$option" = "delete" ]; then
      value="$3"
      if [ -z "$value" ]; then
        echo "Error: You must specify a channel URL"
        exit 1
      fi

      value=$(echo $value | sed 's/\//\\\//g')
      sed -i "/^$value/d" /etc/tor_report_channels.txt
      echo "OK."
    elif [ "$option" = "list" ]; then
      if [ -f "/etc/tor_report_channels.txt" ]; then
        cat /etc/tor_report_channels.txt
      else
        echo "No channels found. No message send"
      fi
    elif [ "$option" = "off" ]; then
      rm -rf /etc/tor_report.sh /etc/cron.d/tor_report /etc/tor_report_channels.txt || true
      echo "OK."
    elif [ "$option" = "now" ]; then
       treehouses feedback "$(treehouses tor)\n$(treehouses tor list | sed '1d' | sed "s/  <=> /:/g" | tr "\n" " " | sed 's/.$//')\n\`$(date -u +"%Y-%m-%d %H:%M:%S %Z")\` $(treehouses networkmode)"
    elif [ -z "$option" ]; then
      if [ -f "/etc/cron.d/tor_report" ]; then
        status="on"
      else
        status="off"
      fi
      echo "Status: $status"
    else
      echo "Error: only 'on' and 'off' options are supported."
    fi
  elif [ "$1" = "status" ]; then
    systemctl is-active tor
  elif [ "$1" = "refresh" ]; then
    cp /etc/tor/torrc /etc/tor/torrc_backup
    treehouses tor destroy
    treehouses tor start
    mv /etc/tor/torrc_backup /etc/tor/torrc
    echo "Success: the tor service has been refreshed"
  else
    echo "Error: only 'list', 'add', 'start', 'stop', 'status', 'notice', 'destroy', 'delete', 'deleteall', and 'refresh' options are supported."
  fi
}

function tor_help {

  echo
  echo "Usage: $BASENAME tor"
  echo
  echo "Setups the tor service on the rpi"
  echo
  echo "Examples:"
  echo "  $BASENAME tor"
  echo "      Outputs the hostname of the tor service"
  echo
  echo "  $BASENAME tor list"
  echo "      Outputs the ports that are exposed on the tor network"
  echo "      Example:"
  echo "        external <=> local"
  echo "        22       <=> 22"
  echo "        80       <=> 80"
  echo "      the port 22 is open and routing the traffic of the local port 22,"
  echo "      the port 80 is open and routing the traffic of the local port 80"
  echo
  echo "  $BASENAME tor add <port> [localport]"
  echo "      Adds the desired port to be accessible from the tor network"
  echo "      Redirects localport to (tor) port"
  echo
  echo "  $BASENAME tor delete <port> [localport]"
  echo "      Deletes the desired port from the tor network"
  echo
  echo "  $BASENAME tor deleteall"
  echo "      Deletes all local ports from the tor network"
  echo
  echo "  $BASENAME tor start"
  echo "      Setups and starts the tor service"
  echo
  echo "  $BASENAME tor stop"
  echo "      Stops the tor service"
  echo
  echo "  $BASENAME tor destroy"
  echo "      Stops and resets the tor configuration"
  echo
  echo "  $BASENAME tor notice <on|off|now|add|delete|list> [api_url]"
  echo "      Enables or disables the propagation of the tor address/ports to gitter"
  echo
  echo "  $BASENAME tor status"
  echo "      Outputs the status of the tor service"
  echo
  echo "  $BASENAME tor refresh"
  echo "      Creates a new tor address while keeping added ports"
  echo
}
