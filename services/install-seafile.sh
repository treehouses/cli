#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/seafile

  # create yml(s)
  {
    echo "version: \"3\""
    echo
    echo "services:"
    echo "  seafile:"
    echo "    container_name: seafile"
    echo "    image: hirotochigi/seafile-rpi"
    echo "    ports:"
    echo "      - \"8085:8000\""
    echo "      - \"8086:8082\""
    echo "    environment:        "
    echo "      -   "
    echo "    volumes:          "
    echo "      - /home/data/seafile:/seafile "
  } > /srv/seafile/seafile.yml

  # add autorun
  {
    echo "seafile_autorun=true"
    echo
    echo "if [ \"\$seafile_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/seafile/seafile.yml -p seafile up -d"
    echo "fi"
    echo
    echo
  } > /srv/seafile/autorun
}

# add port(s)
function get_ports {
  echo "8086"
}

# add size (in MB)
function get_size {
  echo "550"
}

# add info
function get_info {
  echo "https://github.com/treehouses/seafile"
  echo
  echo "\"A minimalist, open source online pastebin where the server has"
  echo "zero knowledge of pasted data. Data is encrypted/decrypted in the"
  echo "browser using 256 bits AES. https://seafile.info/\""
}
