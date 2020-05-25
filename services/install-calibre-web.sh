#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/calibre-web

  # create yml(s)
  cat << EOF > /srv/calibre-web/calibre-web.yml
version: "2.1"
services:
  calibre-web:
    image: linuxserver/calibre-web
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
      - DOCKER_MODS=linuxserver/calibre-web:calibre
    volumes:
      - "/srv/calibre-web.sh:/root/.calibre-web"
      - "/srv/calibre-web.sh:/books
    ports:
      - 8090:8090
    restart: unless-stopped
EOF

  # create .env with default values
  cat << EOF > /srv/calibre-web/.env
PUID=1000
PGID=1000
TZ=Europe/London
PASSWORD=PASSWORD
DB_TYPE=sqlite
DB_NAME=DB_NAME
DB_HOSTNAME=DB_HOSTNAME
DB_USERNAME=DB_USERNAME
DB_PASSWORD=DB_PASSWORD
EOF

  # add autorun
  cat << EOF > /srv/calibre-web/autorun
calibre-web_autorun=true

if [ "$calibre-web_autorun" = true ]; then
  treehouses services librespeed up
fi


EOF
}

# environment var
function uses_env {
  echo true
}

# add supported arm(s)
function supported_arms {
  echo "v7l"
}

# add port(s)
function get_ports {
  echo "8090"
}

# add size (in MB)
function get_size {
  echo "60"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-calibre-web"
  echo
  echo "Calibre-web is a web app providing a clean interface for "
  echo "browsing, reading and downloading eBooks using an existing Calibre database." 
  echo "It is also possible to integrate google drive and edit metadata and"
  echo "your calibre library through the app itself."
}

# add svg icon
# function get_icon {
#   cat <<EOF

# EOF
# }
