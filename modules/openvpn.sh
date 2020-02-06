#!/bin/bash

function openvpn {
  command="$1"

  if ! hash "openvpn" 2>"$LOGFILE"; then
    echo "Error: couldn't find openvpn installed."
    echo "On debian systems it can be installed by running 'apt-get install openvpn'"
    exit 1
  fi

  if [ "$command" == "use" ]; then
    filename="$2"
    password="$3"

    cp "$filename" "/etc/openvpn/openvpn.conf"
    if [ ! -z "$password" ]; then
      echo "askpass /etc/openvpn/auth.txt" >> "/etc/openvpn/openvpn.conf"
      echo "$password" >> "/etc/openvpn/auth.txt"
      chmod 400 "/etc/openvpn/auth.txt"
    else
      rm -rf "/etc/openvpn/auth.txt"
    fi

    restart_service "openvpn"
    enable_service "openvpn"
  elif [ "$command" == "show" ]; then
    if [ -f "/etc/openvpn/openvpn.conf" ]; then
      cat "/etc/openvpn/openvpn.conf"
    else
      echo "openvpn has not been setup yet."
    fi
  elif [ "$command" == "delete" ]; then
    rm -rf "/etc/openvpn/openvpn.conf"
    rm -rf "/etc/openvpn/auth.txt"
  elif [ "$command" == "start" ]; then
    start_service "openvpn"
    enable_service "openvpn"
  elif [ "$command" == "stop" ]; then
    stop_service "openvpn"
    disable_service "openvpn"
  elif [ "$command" == "load" ]; then
    url="$2"
    password="$3"

    if [ -f "/tmp/vpn.ovpn" ]; then
      rm -rf "/tmp/vpn.ovpn";
    fi

    curl -L "$url" -o "/tmp/vpn.ovpn"

    if [ -f "/tmp/vpn.ovpn" ]; then
      openvpn "use" "/tmp/vpn.ovpn" "$password"
    else
      echo "Error when trying to download the vpn file"
    fi

    restart_service "openvpn"
    enable_service "openvpn"
  elif [ "$command" = "notice" ]; then
    option="$2"
    if [ "$option" = "on" ]; then
      cp "$TEMPLATES/network/openvpn_report.sh" /etc/openvpn_report.sh
      if [ ! -f "/etc/cron.d/openvpn_report" ]; then
        echo "*/1 * * * * root if [ -d \"/sys/class/net/tun0\" ]; then /etc/openvpn_report.sh; fi" > /etc/cron.d/openvpn_report
      fi
      if [ ! -f "/etc/openvpn_report_channels.txt" ]; then
        echo "https://api.gitter.im/v1/rooms/5ba5af3cd73408ce4fa8fcfb/chatMessages" >> /etc/openvpn_report_channels.txt
      fi
      echo "OK."
    elif [ "$option" = "add" ]; then
      value="$3"
      if [ -z "$value" ]; then
        echo "Error: You must specify a channel URL"
        exit 1
      fi

      echo "$value" >> /etc/openvpn_report_channels.txt
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
      if [ -f "/etc/openvpn_report_channels.txt" ]; then
        cat /etc/openvpn_report_channels.txt
      else
        echo "No channels found. No message send"
      fi
    elif [ "$option" = "off" ]; then
      rm -rf /etc/openvpn_report.sh /etc/cron.d/openvpn_report /etc/openvpn_report_channels.txt || true
      echo "OK."
    elif [ -z "$option" ]; then
      if [ -f "/etc/cron.d/openvpn_report" ]; then
        status="on"
      else
        status="off"
      fi
      echo "Status: $status"
    else
      echo "Error: only 'on' and 'off' options are supported."
    fi
  elif [ -z "$command" ]; then
    echo "openvpn service"
    echo "running: $(systemctl is-active openvpn)"
    echo "run at boot: $(systemctl is-enabled openvpn)"
    if [ "$(systemctl is-active openvpn)" = "active" ]; then
      echo "ip: $(get_ipv4_ip tun0)"
    fi
  else
    echo "Error: only 'use', 'show', 'delete', 'notice', 'start', 'stop' and 'load' options are supported."
  fi
}


function openvpn_help {
  echo
  echo "Usage: $BASENAME openvpn [use|show|delete|start|stop|load]"
  echo
  echo "Helps setting up an openvpn client"
  echo
  echo "Example:"
  echo "  $BASENAME openvpn                        => shows current status"
  echo "  $BASENAME openvpn use <file> [password]  => copies the opvn file to the right place"
  echo "  $BASENAME openvpn show                   => shows the cert "
  echo "  $BASENAME openvpn delete                 => deletes the cert"
  echo "  $BASENAME openvpn start                  => turns on the ovpn service"
  echo "  $BASENAME openvpn stop                   => turns off the ovpn service"
  echo "  $BASENAME openvpn load <url> [password]  => downloads the cert from a server and uses it"
  echo "  $BASENAME openvpn notice <on|off|add|delete|list> [api_url]"
  echo "    Enables or disables the propagation of the openvpn ip / status to gitter"
  echo
}
