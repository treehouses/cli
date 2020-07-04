#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/jellyfin

  # create yml(s)
  cat << EOF > /srv/jellyfin/jellyfin.yml
version: "2.1"
services:
  jellyfin:
    image: linuxserver/jellyfin
    environment:
      - PUID=\${PUID}
      - PGID=\${PGID}
      - TZ=\${TZ}
    volumes:
      - /path/to/library:/config
      - /path/to/tvseries:/data/tvshows
      - /path/to/movies:/data/movies
    ports:
      - 8096:8096
    restart: unless-stopped
EOF

  # create .env with default values
  cat << EOF > /srv/jellyfin/.env
  PUID=1000
  PGID=1000
  TZ=Europe/London
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
  echo true
}

# add supported arch(es)
function supported_arches {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "8096"
}

# add size (in MB)
function get_size {
  echo "200"
}

# add info
function get_info {
  echo "https://github.com/jellyfin/jellyfin"
  echo
  echo "\"Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg id="banner-logo-solid" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 2560 512" version="1.1">
   <defs>
      <linearGradient id="linear-gradient" x1="110.25" y1="213.3" x2="496.14" y2="436.09" gradientUnits="userSpaceOnUse">
         <stop offset="0" stop-color="#aa5cc3"/>
         <stop offset="1" stop-color="#00a4dc"/>
      </linearGradient>
   </defs>
   <title>banner-logo-solid</title>
   <rect id="solid-background" width="2560" height="512" fill="#000b25" />
   <g id="icon-solid" transform="matrix(0.9776332,0,0,0.97766859,1029.7258,5.7203212)">
      <path id="inner-shape" d="m 256,201.62 c -20.44,0 -86.23,119.29 -76.2,139.43 10.03,20.14 142.48,19.92 152.4,0 9.92,-19.92 -55.73,-139.42 -76.2,-139.43 z" fill="url(#linear-gradient)"/>
      <path id="outer-shape" d="m 256,23.3 c -61.56,0 -259.82,359.43 -229.59,420.13 30.23,60.7 429.34,60 459.24,0 C 515.55,383.43 317.62,23.3 256,23.3 Z m 150.51,367.46 c -19.59,39.33 -281.08,39.77 -300.89,0 -19.81,-39.77 110.09,-275.28 150.44,-275.28 40.35,0 170.04,235.94 150.45,275.28 z" fill="url(#linear-gradient)"/>
   </g>
</svg>
EOF
}