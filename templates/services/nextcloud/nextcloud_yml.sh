#!/bin/bash

#create nextcloud.yml
mkdir -p /srv/nextcloud/data
{
  echo "services:"
  echo "  nextcloud:"
  echo "    image: treehouses/nextcloud"
  echo "    ports:"
  echo "      - \"8081:80\""
  echo "    volumes:"
  echo "      - \"/srv/nextcloud/data:/var/www/html/data\""
  echo "version: \"2\""
} > /srv/nextcloud/nextcloud.yml
