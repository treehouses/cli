#!/bin/bash

# create pihole.yml
mkdir -p /srv/pihole
{
  echo "version: \"3\""
  echo
  echo "# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md"
  echo 
  echo "services:"
  echo "  pihole:"
  echo "    container_name: pihole"
  echo "    image: pihole/pihole:4.3.2-1_armhf"
  echo "    # For DHCP it is recommended to remove these ports and instead add: network_mode: \"host\""
  echo "    ports:"
  echo "      - \"53:53/tcp\""
  echo "      - \"53:53/udp\""
  echo "      - \"67:67/udp\""
  echo "      - \"8053:80/tcp\""
  echo "      - \"443:443/tcp\""
  echo "    environment:"
  echo "      TZ: 'America/New_York'"
  echo "      WEBPASSWORD: ''"
  echo "    # Volumes store your data between container upgrades"
  echo "    volumes:"
  echo "      - './etc-pihole/:/etc/pihole/'"
  echo "      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'"
  echo "    # run $(touch ./var-log/pihole.log) first unless you like errors"
  echo "    # - './var-log/pihole.log:/var/log/pihole.log'"
  echo "    dns:"
  echo "      - 127.0.0.1"
  echo "      - 1.1.1.1"
  echo "    # Recommended but not required (DHCP needs NET_ADMIN)"
  echo "    #   https://github.com/pi-hole/docker-pi-hole#note-on-capabilities"
  echo "    cap_add:"
  echo "      - NET_ADMIN"
  echo "    # restart: unless-stopped"
} > /srv/pihole/pihole.yml
