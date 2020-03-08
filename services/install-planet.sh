#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/planet

  # create yml(s)
  {
    echo "services:"
    echo "  couchdb:"
    echo "    expose:"
    echo "      - 5984"
    echo "    image: treehouses/couchdb:2.3.1"
    echo "    ports:"
    echo "      - \"2200:5984\""
    echo "  db-init:"
    echo "    image: treehouses/planet:db-init-local"
    echo "    depends_on:"
    echo "      - couchdb"
    echo "    environment:"
    echo "      - COUCHDB_HOST=http://couchdb:5984"
    echo "  planet:"
    echo "    image: treehouses/planet:local"
    echo "    ports:"
    echo "      - \"80:80\""
    echo "    volumes:"
    echo "      - \"/var/run/docker.sock:/var/run/docker.sock\""
    echo "    environment:"
    echo "      - MULTIPLE_IPS=true"
    echo "      - HOST_PROTOCOL=http"
    echo "      - DB_HOST=127.0.0.1"
    echo "      - DB_PORT=2200"
    echo "      - CENTER_ADDRESS=planet.earth.ole.org/db"
    echo "    depends_on:"
    echo "      - couchdb"
    echo "version: \"2\""
  } > /srv/planet/planet.yml

  {
    echo "services:"
    echo "  couchdb:"
    echo "    volumes:"
    echo "      - \"/srv/planet/conf:/opt/couchdb/etc/local.d\""
    echo "      - \"/srv/planet/data:/opt/couchdb/data\""
    echo "      - \"/srv/planet/log:/opt/couchdb/var/log\""
    echo "  planet:"
    echo "    volumes:"
    echo "      - \"/srv/planet/pwd:/usr/share/nginx/html/credentials\""
    echo "      - \"/srv/planet/fs:/usr/share/nginx/html/fs\""
    echo "version: \"2\""
  } > /srv/planet/volumes.yml

  # add autorun
  {
    echo "planet_autorun=true"
    echo
    echo "if [ \"\$planet_autorun\" = true ]; then"
    echo "  if [ -f /srv/planet/pwd/credentials.yml ]; then"
    echo "    docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d"
    echo "  else"
    echo "    docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d"
    echo "  fi"
    echo "fi"
    echo
    echo
  } > /srv/planet/autorun
}

# add port(s)
function get_ports {
  echo "80"
  echo "2200"
}

# add size (in MB)
function get_size {
  echo "450"
}

# add info
function get_info {
  echo "https://github.com/open-learning-exchange/planet"
  echo
  echo "\"Planet Learning is a generic learning system built in Angular"
  echo "& CouchDB.\""
}
