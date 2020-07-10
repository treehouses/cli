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
  <svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="225.000000pt" height="225.000000pt" viewBox="0 0 225.000000 225.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
Created by potrace 1.16, written by Peter Selinger 2001-2019
</metadata>
<g transform="translate(0.000000,225.000000) scale(0.100000,-0.100000)"
fill="#000000" stroke="none">
<path d="M277 2106 c-89 -32 -164 -111 -187 -198 -7 -23 -9 -317 -8 -810 l3
-773 23 -43 c33 -62 96 -118 158 -142 53 -20 74 -20 858 -20 908 0 867 -3 956
77 28 25 57 64 71 95 l24 53 0 775 0 775 -24 53 c-31 69 -106 137 -174 157
-72 21 -1640 22 -1700 1z m333 -515 c5 -11 10 -41 10 -67 l0 -46 39 35 c52 47
84 63 155 76 41 8 71 8 97 1 155 -42 151 -235 -5 -270 -110 -24 -223 29 -229
109 -1 21 -2 21 -27 -4 -25 -25 -25 -26 -25 -208 l0 -182 40 -5 c43 -5 57 -28
35 -55 -10 -12 -54 -15 -249 -15 -130 0 -242 4 -249 9 -8 4 -12 19 -10 32 2
20 10 25 41 27 30 3 40 9 47 28 11 27 14 395 4 432 -4 14 -14 22 -28 22 -31 0
-48 15 -44 36 3 16 17 21 78 27 41 5 120 15 175 22 136 17 133 17 145 -4z
m598 -488 c4 -26 -13 -31 -22 -8 -3 8 -12 15 -21 15 -12 0 -15 -13 -15 -65 0
-37 4 -65 10 -65 6 0 10 -4 10 -10 0 -5 -21 -10 -48 -10 l-47 0 3 75 c2 41 1
75 -4 75 -4 0 -16 -7 -26 -17 -17 -15 -18 -15 -18 4 0 31 9 34 95 31 74 -3 80
-5 83 -25z"/>
</g>
</svg>
EOF
}
