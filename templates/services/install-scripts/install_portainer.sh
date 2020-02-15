#!/bin/bash

# create service directory
mkdir -p /srv/portainer

# create yml(s)
{
  echo "services:"
  echo "  portainer:"
  echo "    image: portainer/portainer"
  echo "    ports:"
  echo "      - \"9000:9000\""
  echo "    volumes:"
  echo "      - \"/var/run/docker.sock:/var/run/docker.sock\""
  echo "      - \"portainer_data:/data\""
  echo "version: \"2\""
  echo "volumes:"
  echo "  portainer_data:"
} > /srv/portainer/portainer.yml

# add port(s)
{
  echo "9000"
} > /srv/portainer/ports

# add size (in MB)
{
  echo "100"
} > /srv/portainer/size

# add info
{
  echo "https://github.com/portainer/portainer"
  echo
  echo "\"Portainer is a lightweight management UI which allows you to"
  echo "easily manage your different Docker environments (Docker hosts or"
  echo "Swarm clusters).\""
} > /srv/portainer/info

# add autorun
{
  echo "portainer_autorun=true"
  echo
  echo "if [ \"$portainer_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/portainer/portainer.yml -p portainer up -d"
  echo "fi"
  echo
  echo
} > /srv/portainer/autorun
