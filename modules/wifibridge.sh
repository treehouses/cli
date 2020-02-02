#!/bin/bash

# Share Wifi with Eth device

function wifibridge {

  if [ "$1" == "on" ]; then
    echo on

    ip_address="192.168.2.1"
    netmask="255.255.255.0"
    dhcp_range_start="192.168.2.2"
    dhcp_range_end="192.168.2.100"
    dhcp_time="12h"

    sudo systemctl start network-online.target &> /dev/null

    sudo iptables -F
    sudo iptables -t nat -F
    sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
    sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

    sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

    sudo ifconfig eth0 $ip_address netmask $netmask

    # Remove default route created by dhcpcd
    sudo ip route del 0/0 dev eth0 &> /dev/null

    sudo systemctl stop dnsmasq

    sudo rm -rf /etc/dnsmasq.d/* &> /dev/null

    echo -e "interface=eth0\n\
    bind-interfaces\n\
    server=8.8.8.8\n\
    domain-needed\n\
    bogus-priv\n\
    dhcp-range=$dhcp_range_start,$dhcp_range_end,$dhcp_time" > /tmp/custom-dnsmasq.conf

    sudo cp /tmp/custom-dnsmasq.conf /etc/dnsmasq.d/custom-dnsmasq.conf
    sudo systemctl start dnsmasq
  elif [ "$1" == "off" ]; then
    echo off
    default network
  fi
}
