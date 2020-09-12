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
      - /srv/rutorrent/downloads:/downloads
    ports:
      - 8097:80
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

# add supported arch(es)
function supported_arches {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "8097"
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
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1238 621">
  <defs/>
  <path fill="none" stroke="#b06d00" stroke-linecap="round" stroke-width="5pt" d="M533 434.5v-90"/>
  <path fill="none" stroke="#8000fe" stroke-linecap="round" stroke-width="100pt" d="M533 344.5h90M623 344.5v90M623 434.5h-90M533 434.5v-90M533 344.5h90M623 344.5v90M623 434.5h-90"/>
  <text x="490" y="397.5" fill="rgba(128,0,254,1)" font-family="sans-serif" font-size="100">
    r
  </text>
  <text x="490" y="397.5" fill="rgba(255,255,255,1)" font-family="sans-serif" font-size="100">
    r
  </text>
  <text x="513" y="396.5" fill="rgba(255,255,255,1)" font-family="sans-serif" font-size="40">
    utorrent
  </text>
</svg>
EOF
}
