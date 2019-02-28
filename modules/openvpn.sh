#!/bin/bash
# treehouses openvpn                  => shows current status
# treehouses openvpn use <file> [pwd] => copies the opvn file to the right place
# treehouses openvpn show             => shows the cert 
# treehouses openvpn delete           => deletes the cert
# treehouses openvpn on               => turns on the ovpn service
# treehouses openvpn off              => turns off the ovpn service
# treehouses openvpn download  <url> [vpn_pwd]=> downloads the cert from a server

function openvpn {
  command="$1"

  if [ "$command" == "use" ]; then
    fName="$2"
    pwd="$3"

    cp "$fName" "/etc/openvpn/openvpn.conf"
    if [ ! -z "$pwd" ]; then
      echo "askpass /etc/openvpn/auth.txt" >> "/etc/openvpn/openvpn.conf"
      echo "$pwd" >> "/etc/openvpn/auth.txt"
      chmod 400 "/etc/openvpn/auth.txt"
    else
      rm -rf "/etc/openvpn/auth.txt"
    fi
  elif [ "$command" == "show" ]; then
    if [ -f "/etc/openvpn/openvpn.conf" ]; then
      cat "/etc/openvpn/openvpn.conf"
    else
      echo "openvpn has not ben set-up yet."
    fi
  elif [ "$command" == "delete" ]; then
    rm -rf "/etc/openvpn/openvpn.conf"
    rm -rf "/etc/openvpn/auth.txt"
  elif [ "$command" == "on" ]; then
    start_service "openvpn"
    enable_service "openvpn"
  elif [ "$command" == "off" ]; then
    stop_service "openvpn"
    disable_service "openvpn"
  elif [ "$command" == "load" ]; then
    url="$2"
    pwd="$3"

    if [ -f "/tmp/vpn.ovpn" ]; then
      rm -rf "/tmp/vpn.ovpn";
    fi

    curl -L "$url" -o "/tmp/vpn.ovpn"

    if [ -f "/tmp/vpn.ovpn" ]; then
      openvpn "use" "/tmp/vpn.ovpn" "$pwd"
    else
      echo "Error when trying to download the vpn file"
    fi
  elif [ -z "$command" ]; then
    echo "openvpn service"
    echo "running: $(systemctl is-active openvpn)"
    echo "run at boot: $(systemctl is-enabled openvpn)"
  else
    echo "Error: only 'use', 'show', 'delete', 'on', 'off' and 'load' options are supported."
  fi
}


function openvpn_help {
  echo ""
  echo "Usage: $(basename "$0") openvpn [use|show|delete|on|off|load]"
  echo ""
  echo "Helps setting up an openvpn client"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") openvpn                        => shows current status"
  echo "  $(basename "$0") openvpn use <file> [pwd]       => copies the opvn file to the right place"
  echo "  $(basename "$0") openvpn show                   => shows the cert "
  echo "  $(basename "$0") openvpn delete                 => deletes the cert"
  echo "  $(basename "$0") openvpn on                     => turns on the ovpn service"
  echo "  $(basename "$0") openvpn off                    => turns off the ovpn service"
  echo "  $(basename "$0") openvpn load <url> [vpn_pwd]  => downloads the cert from a server and uses it"
}