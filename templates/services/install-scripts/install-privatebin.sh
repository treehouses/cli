#!/bin/bash

# create service directory
mkdir -p /srv/privatebin

# create yml(s)
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

# add port(s)
{
  echo "8083"
} > /srv/privatebin/ports

# add size (in MB)
{
  echo "550"
} > /srv/privatebin/size

# add info
{
  echo "https://github.com/treehouses/privatebin"
  echo
  echo "\"A minimalist, open source online pastebin where the server has"
  echo "zero knowledge of pasted data. Data is encrypted/decrypted in the"
  echo "browser using 256 bits AES. https://privatebin.info/\""
} > /srv/privatebin/info

# add autorun
{
  echo "privatebin_autorun=true"
  echo
  echo "if [ \"\$privatebin_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/privatebin/privatebin.yml -p privatebin up -d"
  echo "fi"
  echo
  echo
} > /srv/privatebin/autorun
