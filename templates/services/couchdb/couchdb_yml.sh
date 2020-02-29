#!/bin/bash

mkdir -p /srv/couchdb/data
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


