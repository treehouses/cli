#!/bin/bash

#create netdata.yml
mkdir -p /srv/netdata/
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
