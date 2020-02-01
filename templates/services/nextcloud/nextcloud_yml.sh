#!/bin/bash

#create nextcloud.yml

mkdir -p /srv/nextcloud

{
 echo "services:"
 echo "  nextcloud:"
 echo "    image: nextcloud"
 echo "    ports:"
 echo "      - \"8081\""
 echo "version: \"2\""
} > /srv/nextcloud/nextcloud.yml
