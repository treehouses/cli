#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/rutorrent

  # create yml(s)
  cat << EOF > /srv/rutorrent/rutorrent.yml
version: "2.1"
services:
  rutorrent:
    image: linuxserver/rutorrent
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - /srv/rutorrent:/root/.rutorrent
    ports:
      - 8096:80
      - 5000:5000
      - 51413:51413
      - 6881:6881/udp
    restart: unless-stopped
EOF


  # add autorun
  cat << EOF > /srv/rutorrent/autorun
rutorrent_autorun=true

if [ "$rutorrent_autorun" = true ]; then
  treehouses services rutorrent up
fi


EOF
}

# environment var
function uses_env {
  echo false
}

# add supported arm(s)
function supported_arms {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "8096"
  echo "5000"
  echo "51413"
  echo "6881"
}

# add size (in MB)
function get_size {
  echo "162"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-rutorrent.git"
  echo
  echo "Rutorrent is a popular rtorrent client with a webui for ease of use"
}

# add svg icon
function get_icon {
  cat <<EOF
EOF
}
