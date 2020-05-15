#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/unifi-controller

  # create yml(s)
  {
    echo "version: '2.1'"
    echo "services:"
    echo "unifi-controller:"
    echo "image: linuxserver/unifi-controller"
    echo "container_name: unifi-controller"
    echo "environment:"
    echo "  - PUID=\${PUID}"
    echo "  - PGID=\${PGID}"
    echo "  - MEM_LIMIT=\${MEM_LIMIT}"
    echo "ports:"
    echo "  - 3478:3478/udp"
    echo "  - 10001:10001/udp"
    echo "  - 10002:10002"
    echo "  - 8081:8081"
    echo "  - 8443:8443"
    echo "  - 8843:8843"
    echo "  - 8880:8880"
    echo "  - 6789:6789"
    echo "restart: unless-stopped"
  } > /srv/unifi-controller/unifi-controller.yml

  # create .env with default values
  {
    echo "- PUID=1000"
    echo "- PGID=1000"
    echo "- MEM_LIMIT=1024M #optional"
  } > /srv/unifi-controller/.env

  # add autorun
  {
    echo "unifi-controller_autorun=true"
    echo
    echo "if [ \"\$unifi-controller_autorun\" = true ]; then"
    echo "  treehouses services unifi-controller up"
    echo "fi"
    echo
    echo
  } > /srv/unifi-controller/autorun
}

# environment var
function uses_env {
  echo true
}

# add supported arm(s)
function supported_arms {
  echo "v7l"
  echo "v6l"
}

# add port(s)
function get_ports {
  echo "3478"
  echo "10001"
  echo "10002"
  echo "8081"
  echo "8443"
  echo "8843"
  echo "8880"
  echo "6789"
}

# add size (in MB)
function get_size {
  echo "277"
}

# add info
function get_info {
  echo "https://www.ubnt.com/enterprise/#unifi"
  echo
  echo "The Unifi-controller Controller software is a powerful, enterprise"
  echo "wireless software engine ideal for high-density client deployments"
  echo "requiring low latency and high uptime performance"
}

# add svg icon
function get_icon {
  cat <<EOF
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="395.000000pt" height="200.000000pt" viewBox="0 0 395.000000 200.000000" preserveAspectRatio="xMidYMid meet">
  <metadata>
Created by potrace 1.16, written by Peter Selinger 2001-2019
</metadata>
  <g transform="translate(0.000000,200.000000) scale(0.100000,-0.100000)" fill="#000000" stroke="none">
    <path d="M2132 1965 c-246 -45 -451 -163 -577 -334 -76 -104 -150 -289 -169 -423 l-7 -48 95 0 c96 0 96 0 96 25 0 43 58 208 97 275 21 35 68 94 104 131 132 133 289 192 568 212 l35 2 18 80 c9 44 18 83 18 88 0 12 -199 6 -278 -8z"/>
    <path d="M2208 1670 c-183 -31 -350 -139 -436 -283 -32 -53 -82 -183 -82 -213 0 -11 20 -14 95 -14 69 0 95 3 95 13 0 30 63 141 106 187 25 27 73 63 105 79 52 26 88 36 196 57 22 4 31 32 49 144 l7 40 -44 -1 c-24 -1 -65 -5 -91 -9z"/>
    <path d="M277 1328 c-48 -194 -200 -934 -204 -994 -14 -209 71 -300 292 -311 252 -13 414 80 494 285 16 39 231 1007 231 1037 0 3 -49 5 -110 5 -60 0 -110 -2 -110 -4 0 -2 -47 -224 -105 -492 -116 -540 -127 -575 -203 -628 -35 -25 -55 -31 -111 -34 -111 -7 -161 36 -161 136 0 29 171 855 207 1000 5 22 4 22 -105 22 -106 0 -110 -1 -115 -22z"/>
    <path d="M2200 1341 c-42 -13 -84 -38 -114 -68 -29 -28 -66 -82 -66 -95 0 -5 49 -8 108 -8 l109 0 16 78 c9 42 17 83 17 90 0 13 -31 15 -70 3z"/>
    <path d="M2287 708 c-76 -354 -138 -649 -137 -656 0 -10 25 -12 107 -10 l107 3 48 220 c26 121 55 253 63 293 l16 72 229 0 229 0 16 78 c9 42 19 85 22 95 4 16 -12 17 -227 17 -182 0 -231 3 -228 13 3 6 20 85 39 174 l33 163 230 2 230 3 18 75 c9 41 17 81 18 88 0 9 -74 12 -338 12 l-338 0 -137 -642z"/>
    <path d="M3223 1263 l-20 -88 95 -3 c52 -1 97 -1 99 2 3 3 2 21 -1 41 -11 56 -91 135 -139 135 -9 0 -20 -29 -34 -87z"/>
    <path d="M3680 1260 c0 -73 3 -90 15 -90 11 0 15 13 16 53 l0 52 21 -52 c14 -37 26 -53 39 -53 12 0 23 16 36 53 l18 52 3 -52 c2 -38 7 -53 18 -53 11 0 14 18 14 91 0 87 -1 90 -21 87 -17 -2 -27 -17 -42 -60 -12 -32 -24 -58 -28 -58 -3 0 -16 27 -28 60 -17 45 -27 60 -42 60 -17 0 -19 -7 -19 -90z"/>
    <path d="M1543 1050 c-56 -12 -116 -44 -165 -88 -31 -28 -40 -32 -35 -17 3 11 8 35 12 53 l7 32 -100 0 -99 0 -101 -477 c-56 -263 -102 -486 -102 -495 0 -16 11 -18 99 -18 86 0 100 2 105 18 3 9 37 165 76 346 53 245 78 343 98 379 73 135 262 144 262 12 0 -14 -34 -182 -75 -375 -41 -193 -75 -357 -75 -365 0 -13 16 -15 102 -13 l103 3 83 385 c70 327 82 397 80 462 -3 82 -20 113 -79 144 -34 17 -143 25 -196 14z"/>
    <path d="M2000 1024 c0 -9 -200 -946 -206 -966 -5 -16 4 -18 100 -18 91 0 105 2 110 18 7 23 206 956 206 965 0 4 -47 7 -105 7 -58 0 -105 -3 -105 -6z"/>
    <path d="M3071 548 c-56 -266 -102 -489 -101 -496 0 -10 24 -12 102 -10 l101 3 103 480 c57 264 104 486 104 493 0 9 -27 12 -103 12 l-103 0 -103 -482z"/>
  </g>
</svg>
EOF
}
