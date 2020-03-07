#!/bin/bash

# create service directory
mkdir -p /srv/kolibri

# create yml(s)
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

# add autorun
{
  echo "kolibri_autorun=true"
  echo
  echo "if [ \"\$kolibri_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/kolibri/kolibri.yml -p kolibri up -d"
  echo "fi"
  echo
  echo
} > /srv/kolibri/autorun

# add port(s)
function get_ports {
  echo "8080"
}

# add size (in MB)
function get_size {
  echo "650"
}

# add info
function get_info {
  echo "https://github.com/treehouses/kolibri"
  echo
  echo "\"Kolibri is the offline learning platform from Learning Equality.\""
}
