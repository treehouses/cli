function torproxy {
  checkargn $# 1
  checkroot
  non_tor="192.168.1.0/24 192.168.0.0/24"
  tor_uid=$(id -u debian-tor)
  if [ "$1" == "" ]; then
    torproxy_help
  elif [ "$1" == "on" ]; then
    systemctl start tor
    echo "starting tor .."
    if [ ! -f /etc/tor/torrc.bak ]; then
      cp /etc/tor/torrc /etc/tor/torrc.bak
      echo "VirtualAddrNetwork 10.192.0.0/10" >> /etc/tor/torrc
      echo "TransPort 9040" >> /etc/tor/torrc
      echo "DNSPort 5353" >> /etc/tor/torrc
      echo "SocksPort 9050" >> /etc/tor/torrc
      echo "Log notice file /var/log/tor/notices.log" >> /etc/tor/torrc
      echo "AutomapHostsSuffixes .onion,.exit" >> /etc/tor/torrc
      echo "AutomapHostsOnResolve" >> /etc/tor/torrc
    fi
    if [ ! -f tempfile ]; then
      iptables-save > tempfile
    fi
      iptables -F
      iptables -t nat -F
      iptables -t nat -A OUTPUT -m owner --uid-owner $tor_uid -j RETURN
      iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5353
      for net in $non_tor 127.0.0.0/9 127.128.0.0/10; do
        iptables -t nat -A OUTPUT -d $net -j RETURN
      done
      iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
      iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      for net in $non_tor 127.0.0.0/8; do
        iptables -A OUTPUT -d $net -j ACCEPT
      done
      iptables -A OUTPUT -m owner --uid-owner $tor_uid -j ACCEPT
      iptables -A OUTPUT -j REJECT
      systemctl restart tor
    echo "tor started"
    curl https://check.torproject.org/ | grep "Congratulations."
  elif [ "$1" == "off" ]; then
    if [ -f /etc/tor/torrc.bak ]; then
      mv /etc/tor/torrc.bak /etc/tor/torrc
    fi
    iptables-restore < tempfile
    rm -f tempfile
    systemctl restart tor
    echo "torproxy removed successfully"
  else
    echo "Error: only on and off options are supported"
  fi
}

function torproxy_help {
  echo
  echo "Usage: $BASENAME torproxy [on|off]"
  echo
  echo "Raspberry pi works as a torproxy"
  echo
  echo "Example:"
  echo
  echo "  $BASENAME torproxy on"
  echo "      Setup raspberry pi as a torproxy"
  echo
  echo "  $BASENAME torproxy off"
  echo "      Remove torproxy"
  echo
}
