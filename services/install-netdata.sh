#!/bin/bash

# create service directory
mkdir -p /srv/netdata

# create yml(s)
{
  echo "version: '3'"
  echo "services:"
  echo "  netdata:"
  echo "    image: netdata/netdata"
  echo "    ports:"
  echo "      - 19999:19999"
  echo "    cap_add:"
  echo "      - SYS_PTRACE"
  echo "    security_opt:"
  echo "      - apparmor:unconfined"
  echo "    volumes:"
  echo "      - /etc/passwd:/host/etc/passwd:ro"
  echo "      - /etc/os-release:/host/etc/os-release:ro"
  echo "      - /etc/group:/host/etc/group:ro"
  echo "      - /proc:/host/proc:ro"
  echo "      - /sys:/host/sys:ro"
} > /srv/netdata/netdata.yml

# add autorun
{
  echo "netdata_autorun=true"
  echo
  echo "if [ \"\$netdata_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/netdata/netdata.yml -p netdata up -d"
  echo "fi"
  echo
  echo
} > /srv/netdata/autorun

# add port(s)
function get_ports {
  echo "19999"
}

# add size (in MB)
function get_size {
  echo "300"
}

# add info
function get_info {
  echo "https://github.com/netdata/netdata"
  echo
  echo "\"Netdata is distributed, real-time performance and health monitoring"
  echo "for systems and applications. It is a highly-optimized monitoring agent"
  echo "you install on all your systems and containers.\""
}
