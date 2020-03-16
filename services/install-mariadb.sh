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
    echo "    container_name: rpi-mariadb"
    echo "    ports:"
    echo "      - 3306:3306"
    echo "    environment:"
    echo "      - MYSQL_ROOT_PASSWORD=my-secret-pw"
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
  echo "https://mariadb.org/"
  echo
  echo "MariaDB is a community-developed fork of the MySQL relational database management system"
  echo "Connect to database with 'mysql -h\"127.0.0.1\" -P\"3306\" -uroot -p\"my-secret-pw\"'"
}
