#!/bin/bash

#create portainer.yml
mkdir -p /srv/portainer
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
