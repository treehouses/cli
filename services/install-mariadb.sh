#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/mariadb

  # create yml(s)
  {
    echo "version: '3'"
    echo "services:"
    echo "  mariadb:"
    echo "    image: jsurf/rpi-mariadb"
    echo "    ports:"
    echo "      - 3306:3306"
    echo "    environment:"
    echo "      - MYSQL_ROOT_PASSWORD=my-secret-pw"
#    echo "    cap_add:"
#    echo "      - SYS_PTRACE"
#    echo "    security_opt:"
#    echo "      - apparmor:unconfined"
#    echo "    volumes:"
#    echo "      - /etc/passwd:/host/etc/passwd:ro"
#    echo "      - /etc/os-release:/host/etc/os-release:ro"
#    echo "      - /etc/group:/host/etc/group:ro"
#    echo "      - /proc:/host/proc:ro"
#    echo "      - /sys:/host/sys:ro"
  } > /srv/mariadb/mariadb.yml

  # add autorun
  {
    echo "mariadb_autorun=true"
    echo
    echo "if [ \"\$mariadb_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/mariadb/mariadb.yml -p mariadb up -d"
    echo "fi"
    echo
    echo
  } > /srv/mariadb/autorun
}

# add port(s)
function get_ports {
  echo "3306"
}

# add size (in MB)
function get_size {
  echo "275"
}

# add info
function get_info {
  echo "https://github.com/JSurf/docker-rpi-mariadb"
  echo
  echo "MariaDB is a community-developed fork of the MySQL relational database management system"
}
