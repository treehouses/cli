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

# add autorun
{
  echo "nextcloud_autorun=true"
  echo
  echo "if [ \"\$nextcloud_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/nextcloud/nextcloud.yml -p nextcloud up -d"
  echo "fi"
  echo
  echo
} > /srv/nextcloud/autorun

# add port(s)
function get_ports {
  echo "8081"
}

# add size (in MB)
function get_size {
  echo "900"
}

# add info
function get_info {
  echo "https://github.com/nextcloud"
  echo
  echo "\"A safe home for all your data. Access & share your files, calendars,"
  echo "contacts, mail & more from any device, on your terms.\""
}
