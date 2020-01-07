#!/bin/bash

# create pihole.yml
mkdir -p /srv/privatebin
{
  echo "version: \"3\""
  echo
  echo "services:"
  echo "  privatebin:"
  echo "    container_name: privatebin"
  echo "    image: treehouses/privatebin"
  echo "    ports:"
  echo "      - \"8083:80\""
} > /srv/privatebin/privatebin.yml

