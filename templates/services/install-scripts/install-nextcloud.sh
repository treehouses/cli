#!/bin/bash

# create service directory
mkdir -p /srv/nextcloud

# create yml(s)
{
  echo "services:"
  echo "  nextcloud:"
  echo "    image: nextcloud"
  echo "    ports:"
  echo "      - \"8081:80\""
  echo "    volumes:"
  echo "      - \"/srv/nextcloud/data:/var/www/html/data\""
  echo "version: \"2\""
} > /srv/nextcloud/nextcloud.yml

# add port(s)
{
  echo "8081"
} > /srv/nextcloud/ports

# add size (in MB)
{
  echo "900"
} > /srv/nextcloud/size

# add info
{
  echo "https://github.com/nextcloud"
  echo
  echo "\"A safe home for all your data. Access & share your files, calendars,"
  echo "contacts, mail & more from any device, on your terms.\""
} > /srv/nextcloud/info

# add autorun
{
  echo "nextcloud_autorun=true"
  echo
  echo "if [ \"$nextcloud_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/nextcloud/nextcloud.yml -p nextcloud up -d"
  echo "fi"
  echo
  echo
} > /srv/nextcloud/autorun
