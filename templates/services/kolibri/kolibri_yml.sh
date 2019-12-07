#!/bin/bash

# create kolibri.yml
mkdir -p /srv/kolibri
{
  echo "services:"
  echo "  kolibri:"
  echo "    image: treehouses/kolibri"
  echo "    ports:"
  echo "      - \"8080:8080\""
  echo "    volumes:"
  echo "      - \"/srv/kolibri:/root/.kolibri\""
  echo "version: \"2\""
} > /srv/kolibri/kolibri.yml
