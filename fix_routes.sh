ip r del 0.0.0.0/1 via 192.168.255.5 dev tun0
ip r add 192.168.255.0/24 dev tun0
