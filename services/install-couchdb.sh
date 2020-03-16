#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/couchdb

  # create yml(s)
  {
    echo "version: \"2\""
    echo "services:"
    echo "  couchdb:"
    echo "    image: treehouses/couchdb:2.3.1"
    echo "    ports:"
    echo "      - \"5984:5984\""
    echo "    volumes:"
    echo "      - \"/srv/couchdb/data:/opt/couchdb/data\""
    echo "      - \"/srv/couchdb/log:/opt/couchdb/var/log\""
  } > /srv/couchdb/couchdb.yml

  # add autorun
  {
    echo "couchdb_autorun=true"
    echo
    echo "if [ \"\$couchdb_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/couchdb/couchdb.yml -p couchdb up -d"
    echo "fi"
    echo
    echo
  } > /srv/couchdb/autorun
}

# add port(s)
function get_ports {
  echo "5984"
}

# add size (in MB)
function get_size {
  echo "350"
}

# add info
function get_info {
  echo "https://github.com/treehouses/rpi-couchdb"
  echo "https://github.com/docker-library/docs/tree/master/couchdb"
  echo
  echo "\"Apache CouchDB lets you access your data where you need it by defining the"
  echo "Couch Replication Protocol that is implemented by a variety of projects and products"
  echo "that span every imaginable computing environment from globally distributed server-clusters,"
  echo "over mobile phones to web browsers.\""
}
