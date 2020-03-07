#!/bin/bash

# create service directory
mkdir -p /srv/portainer

function install {
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

  # add autorun
  {
    echo "portainer_autorun=true"
    echo
    echo "if [ \"\$portainer_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/portainer/portainer.yml -p portainer up -d"
    echo "fi"
    echo
    echo
  } > /srv/portainer/autorun
}

# add port(s)
function get_ports {
  echo "9000"
}

# add size (in MB)
function get_size {
  echo "100"
}

# add info
function get_info {
  echo "https://github.com/portainer/portainer"
  echo
  echo "\"Portainer is a lightweight management UI which allows you to"
  echo "easily manage your different Docker environments (Docker hosts or"
  echo "Swarm clusters).\""
}
