#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/jellyfin
  mkdir -p /srv/jellyfin/movies
  mkdir -p /srv/jellyfin/tvshows
  mkdir -p /srv/jellyfin/library/movies
  mkdir -p /srv/jellyfin/library/tvshows

  # create yml(s)
  cat << EOF > /srv/jellyfin/jellyfin.yml
version: "2.1"
services:
  jellyfin:
    image: linuxserver/jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - UMASK_SET=022
    volumes:
      - /srv/jellyfin/library/jellyfin:/root/.jellyfin
      - /srv/jellyfin/library/tvshows:/srv/jellyfin/library/tvshows
      - /srv/jellyfin/library/movies:/srv/jellyfin/library/movies
    ports:
      - 8096:8096
      - 8920:8920
    devices:
      - /dev/dri:/dev/dri
      - /dev/vcsm:/dev/vcsm
      - /dev/vchiq:/dev/vchiq
      - /dev/video10:/dev/video10
      - /dev/video11:/dev/video11
      - /dev/video12:/dev/video12  
    restart: unless-stopped
EOF

  # add autorun
  cat << EOF > /srv/jellyfin/autorun
jellyfin_autorun=true

if [ "$jellyfin_autorun" = true ]; then
  treehouses services jellyfin up
fi


EOF
}

# environment var
function uses_env {
  echo false
}

# add supported arch(es)
function supported_arms {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "8096"
  echo "8920"
}

# add size (in MB)
function get_size {
  echo "200"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-jellyfin"
  echo
  echo "\"Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2560 512">
  <defs/>
  <defs>
    <linearGradient id="a" x1="110.25" x2="496.14" y1="213.3" y2="436.09" gradientUnits="userSpaceOnUse">
      <stop offset="0" stop-color="#aa5cc3"/>
      <stop offset="1" stop-color="#00a4dc"/>
    </linearGradient>
  </defs>
  <path fill="#000b25" d="M0 0h2560v512H0z"/>
  <g fill="url(#a)" transform="matrix(.97763 0 0 .97767 1029.7258 5.7203212)">
    <path d="M256 201.62c-20.44 0-86.23 119.29-76.2 139.43 10.03 20.14 142.48 19.92 152.4 0 9.92-19.92-55.73-139.42-76.2-139.43z"/>
    <path d="M256 23.3c-61.56 0-259.82 359.43-229.59 420.13 30.23 60.7 429.34 60 459.24 0C515.55 383.43 317.62 23.3 256 23.3zm150.51 367.46c-19.59 39.33-281.08 39.77-300.89 0-19.81-39.77 110.09-275.28 150.44-275.28 40.35 0 170.04 235.94 150.45 275.28z"/>
  </g>
</svg>
EOF
}
