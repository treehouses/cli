function tor {
  local port local_port existing_port option value status
  checkroot
  checkargn $# 3
  #check_missing_packages "tor" "curl"

  if { [ ! -d "/var/lib/tor/treehouses" ] || [ ! -f "/var/lib/tor/treehouses/hostname" ]; } && [ "$1" != "start" ] && [ "$1" != "add" ]; then
    if [ -z "$(grep -Poi "^HiddenServicePort \\K(.*) 127.0.0.1:(.*)\\b" /usr/local/etc/tor/torrc.sample | tac | sed -r 's/(.*?)127.0.0.1:(.*?)/\1 <=> \2/g')" ]; then
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

  case "$1" in
    list)
      echo "external <=> local"
      grep -Poi "^HiddenServicePort \\K(.*) 127.0.0.1:(.*)\\b" /usr/local/etc/tor/torrc.sample | tac | sed -r 's/(.*?)127.0.0.1:(.*?)/\1 <=> \2/g'
      ;;

    ports)
      ports=$(grep -Poi "^HiddenServicePort \\K(.*) 127.0.0.1:(.*)\\b" /usr/local/etc/tor/torrc.sample | tac | sed -r 's/(.*?)127.0.0.1:(.*?)/\1 <=> \2/g' | sed "s/  <=> /:/g" | tr "\n" " " | sed "s/ $/\n/")
      if [[ $ports ]]; then
        echo $ports
      else
        echo "No ports found"
      fi
      ;;

    add)
      if ! grep -Pq "^HiddenServiceDir .*" "/usr/local/etc/tor/torrc.sample"; then
        echo "HiddenServiceDir /var/lib/tor/treehouses" >> /usr/local/etc/tor/torrc.sample
      fi

      port="$2"
      local_port="$3"

      if [ -z "$port" ]; then
        log_and_exit1 "Error: you must specify a port"
      fi

      if  ! [[ "$port" =~ ^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$ ]]; then
        log_and_exit1 "Error: is not a port"
      fi

      if [ -z "$local_port" ]; then
        local_port="$port"
      fi

      if  ! [[ "$local_port" =~ ^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$ ]]; then
        log_and_exit1 "Error: is not a port"
      fi

      existing_port=$(grep -Poi "^HiddenServicePort $port .*" /etc/tor/torrc)
      if [ ! -z "$existing_port" ]; then
        sed -i "s/$existing_port/HiddenServicePort $port 127.0.0.1:$local_port/g" /etc/tor/torrc
      else
        echo "HiddenServicePort $port 127.0.0.1:$local_port " >> /etc/tor/torrc
      fi

      restart_service tor
      echo "Success: the port has been added"
      ;;

    delete)
      if [ -z "$2" ]; then
        log_and_exit1 "Error: no port entered"
      fi

      if  ! [[ "$2" =~ ^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$ ]]; then
        log_and_exit1 "Error: $2 is not a port"
      fi

      if ! grep -wq "HiddenServicePort $2" /etc/tor/torrc ; then
        echo "Port $2 is not assigned"
        exit 0
      fi

      sed -i "/^HiddenServicePort $2 /d" /etc/tor/torrc
      restart_service tor
      echo "Port $2 has been deleted"
      ;;

    deleteall)
      if [ -n "$2" ]; then
        log_and_exit1 "Error: wrong syntax"
      fi

      sed -i "/^HiddenServicePort /d" /etc/tor/torrc
      restart_service tor
      echo "All ports have been deleted"
      ;;

    stop)
      stop_service tor
      echo "Success: the tor service has been stopped"
      ;;

    start)
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
      ;;

    destroy)
      stop_service tor
      echo > /etc/tor/torrc
      rm -rf /var/lib/tor/treehouses

      echo "Success: the tor service has been destroyed"
      ;;

    notice)
      option="$2"
      case "$option" in
        on)
          cp "$TEMPLATES/network/tor_report.sh" /etc/tor_report.sh
          if [ ! -f "/etc/cron.d/tor_report" ]; then
            echo "*/1 * * * * root if [ -d \"/var/lib/tor/treehouses\" ]; then /etc/tor_report.sh; fi" > /etc/cron.d/tor_report
          fi
          if [ ! -f "/etc/tor_report_channels.txt" ]; then
            echo "https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages" >> /etc/tor_report_channels.txt
          fi
          echo "OK."
          ;;
        add)
          value="$3"
          if [ -z "$value" ]; then
            log_and_exit1 "Error: You must specify a channel URL"
          fi

          echo "$value" >> /etc/tor_report_channels.txt
          echo "OK."
          ;;
        delete)
          value="$3"
          if [ -z "$value" ]; then
            log_and_exit1 "Error: You must specify a channel URL"
          fi

          value=$(echo $value | sed 's/\//\\\//g')
          sed -i "/^$value/d" /etc/tor_report_channels.txt
          echo "OK."
          ;;
        list)
          if [ -f "/etc/tor_report_channels.txt" ]; then
            cat /etc/tor_report_channels.txt
          else
            echo "No channels found. No message send"
          fi
          ;;
        off)
          rm -rf /etc/tor_report.sh /etc/cron.d/tor_report /etc/tor_report_channels.txt || true
          echo "OK."
          ;;
        now)
          line1=$(</var/lib/tor/treehouses/hostname)
          line2=$(grep ^HiddenServicePort /etc/tor/torrc | cut -f 2- -d ' ' | sed -r 's/(.*?) 127.0.0.1:(.*?)/\1:\2/g' | tac | tr -d '\n')
          line3="\`$(date -u +"%Y-%m-%d %H:%M:%S %Z")\` $(treehouses networkmode)"
          feedback "$line1\n$line2\n$line3"
          ;;
        "")
          if [ -f "/etc/cron.d/tor_report" ]; then
            status="on"
          else
            status="off"
          fi
          echo "Status: $status"
          ;;
        *)
          echo "Error: only 'on', 'off', 'now', 'add', 'delete', and 'list' options are supported."
          ;;
      esac
      ;;

    status)
      systemctl is-active tor
      ;;

    refresh)
      cp /etc/tor/torrc /etc/tor/torrc_backup
      treehouses tor destroy
      treehouses tor start
      mv /etc/tor/torrc_backup /etc/tor/torrc
      echo "Success: the tor service has been refreshed"
      ;;

    *)
      echo "Error: only 'list', 'ports', 'add', 'start', 'stop', 'status', 'notice', 'destroy', 'delete', 'deleteall', and 'refresh' options are supported."
      ;;
  esac
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
  echo "  $BASENAME tor ports"
  echo "      Outputs the ports that are exposed on the tor network"
  echo "      Example:"
  echo "        22:22 80:80 2200:2200"
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
