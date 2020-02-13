#!/bin/bash

mkdir -p /srv/planet
# create planet.yml
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

# create volumes.yml
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
