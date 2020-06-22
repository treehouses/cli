#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/pylon

  # create yml(s)
  cat << EOF > /srv/pylon/pylon.yml
version: "2.1"
services:
  pylon:
    image: linuxserver/pylon
    environment:
      - PYUSER=\${USER}
      - PYPASS=\${PASS}
    ports:
      - 3131:3131
    restart: unless-stopped
EOF

  # create .env with default values
  cat << EOF > /srv/pylon/.env
USER=root
PASS=root
EOF

  # add autorun
  cat << EOF > /srv/pylon/autorun
pylon_autorun=true

if [ \"\$pylon_autorun\" = true ]; then
  treehouses services pylon up
fi


EOF
}

# environment var
function uses_env {
  echo true
}

# add supported arm(s)
function supported_arms {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "3131"
}

 #add size (in MB)
function get_size {
  echo "255"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-pylon.git"
  echo
  echo "\"Pylon is a web based integrated development environment built with Node.js as a backend and with a supercharged JavaScript/HTML5 frontend\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="349.3333333" height="256" version="1.0" viewBox="0 0 262 192">
  <defs/>
  <g transform="matrix(.1 0 0 -.1 0 192)">
    <path d="M0 960 l0 -960 1310 0 1310 0 0 960 0 960 -1310 0 -1310 0 0 -960z m1377 746 c73 -34 106 -87 111 -175 3 -64 2 -70 -53 -176 -32 -60 -63 -119 -71 -129 -13 -19 -7 -24 92 -79 125 -70 158 -78 197 -47 33 26 37 85 8 121 -36 45 -141 21 -141 -31 0 -9 -3 -19 -6 -23 -11 -11 -114 46 -114 64 0 9 13 35 30 57 75 104 232 117 323 26 46 -46 60 -90 55 -169 -7 -118 -84 -189 -203 -189 -67 -1 -62 -3 -439 204 -203 112 -238 122 -277 83 -32 -32 -30 -90 5 -119 15 -13 40 -24 55 -24 34 0 81 35 81 60 0 31 13 30 68 -2 44 -25 52 -33 46 -52 -29 -93 -141 -152 -245 -128 -103 24 -162 99 -162 204 0 123 85 211 203 211 52 0 72 -6 178 -61 90 -46 123 -58 130 -49 5 7 32 55 61 108 60 113 66 156 25 188 -36 28 -79 27 -109 -4 -46 -45 -26 -126 35 -142 l29 -8 -32 -58 -33 -57 -45 23 c-101 54 -137 174 -85 281 52 106 171 144 283 92z m-935 -966 c44 -13 93 -52 113 -91 23 -43 19 -49 -31 -49 -38 0 -51 5 -74 30 -39 42 -90 42 -132 0 -28 -28 -30 -35 -26 -82 4 -40 12 -57 32 -75 40 -34 90 -31 126 7 23 25 36 30 74 30 30 0 46 -4 46 -12 0 -26 -41 -78 -81 -105 -81 -53 -202 -30 -260 50 -54 74 -48 176 14 243 51 55 124 75 199 54z m268 -140 l0 -150 61 0 60 0 -3 -42 -3 -43 -107 -3 -108 -3 0 196 0 195 50 0 50 0 0 -150z m383 139 c47 -13 106 -63 123 -106 16 -37 18 -111 5 -146 -33 -86 -141 -142 -229 -118 -124 33 -185 155 -133 266 42 91 134 132 234 104z m275 -128 c1 -79 7 -140 14 -148 7 -8 35 -13 79 -13 l69 0 0 150 0 150 45 0 45 0 -2 -192 -3 -193 -125 0 c-215 0 -224 13 -221 318 l1 68 48 -3 47 -3 3 -134z m542 112 c98 -61 117 -226 34 -308 -40 -41 -108 -58 -209 -53 l-70 3 -3 180 c-1 98 0 186 3 193 4 11 27 13 108 10 83 -3 109 -7 137 -25z m417 -2 c77 -35 120 -134 93 -217 -7 -22 -46 -101 -87 -176 l-75 -138 -64 0 c-35 0 -64 2 -64 5 0 3 41 79 90 168 50 90 90 173 90 186 0 55 -46 88 -99 70 -60 -21 -65 -107 -7 -136 17 -8 32 -17 34 -18 6 -5 -51 -95 -62 -95 -25 0 -87 53 -106 90 -22 43 -27 121 -9 167 14 37 57 82 94 99 43 19 123 17 172 -5z"/>
    <path d="M969 631c-64-64-21-181 66-181 27 0 44 8 66 29 64 64 21 181-66 181-27 0-44-8-66-29zM1760 555l0-105 29 0c51 0 81 18 97 57 32 76-11 153-86 153l-40 0 0-105z"/>
  </g>
</svg>
EOF
}
