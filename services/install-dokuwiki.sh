#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/dokuwiki

  # create yml(s)
  cat << EOF > /srv/dokuwiki/dokuwiki.yml
version: "2.1"
services:
  dokuwiki:
    image: linuxserver/dokuwiki
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /srv/dokuwiki:/root/.dokuwiki
    ports:
      - 443:80
    restart: unless-stopped
EOF


  # add autorun
  cat << EOF > /srv/dokuwiki/autorun
dokuwiki_autorun=true

if [ "$dokuwiki_autorun" = true ]; then
  treehouses services dokuwiki up
fi


EOF
}

# environment var
function uses_env {
  echo false
}

# add supported arm(s)
function supported_arms {
  echo "v7l"
}

# add port(s)
function get_ports {
  echo "443"
}

# add size (in MB)
function get_size {
  echo "146"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-dokuwiki"
  echo
  echo "Dokuwiki is a simple to use and highly versatile Open Source wiki software that doesn't require a database."
  echo "it is of clean and readable syntax, of easy maintenance, backup and integration"
}

# add svg icon
function get_icon {
  cat <<EOF
<svg>
</svg>
EOF
}
