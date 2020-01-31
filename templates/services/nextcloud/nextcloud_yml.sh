#!/bin/bash

#create nextcloud.yml

mkdir -p /srv/nextcloud

{
 echo "services:"
 echo "  nextcloud:"
 echo "    image: treehouses/nextcloud"
 echo "    ports:"
 echo "      - \"8081:80\""
 echo "version: \"2\""
} > /srv/nextcloud/nextcloud.yml
