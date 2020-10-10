#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/librespeed

  # create yml(s)
  cat << EOF > /srv/librespeed/librespeed.yml
version: "2.1"
services:
  librespeed:
    image: linuxserver/librespeed
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - PASSWORD=${PASSWORD}
      - DB_TYPE=${DB_TYPE}
      - DB_NAME=${DB_NAME}
      - DB_HOSTNAME=${DB_HOSTNAME}
      - DB_USERNAME=${DB_USERNAME}
      - DB_PASSWORD=${DB_PASSWORD}
    ports:
      - 8089:80
    volumes:
      - "/srv/librespeed:/root/.librespeed"
    restart: unless-stopped
EOF

  # create .env with default values
  cat << EOF > /srv/librespeed/.env
PASSWORD=PASSWORD
DB_TYPE=sqlite
DB_NAME=DB_NAME
DB_HOSTNAME=DB_HOSTNAME
DB_USERNAME=DB_USERNAME
DB_PASSWORD=DB_PASSWORD
EOF

  # add autorun
  cat << EOF > /srv/librespeed/autorun
librespeed_autorun=true

if [ "$librespeed_autorun" = true ]; then
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
  echo "armv7l"
  echo "x86_64"
  echo "aarch64"
}

# add port(s)
function get_ports {
  echo "8089"
}

# add size (in MB)
function get_size {
  echo "28"
}

# add info
function get_info {
  echo "https://github.com/librespeed/speedtest"
  echo
  echo "Librespeed is a very lightweight Speedtest implemented in"
  echo "Javascript, using XMLHttpRequest and Web Workers. No Flash,"
  echo "No Java, No Websocket, No Bull."
}

# add svg icon
function get_icon {
  cat <<EOF
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="2772.000000pt" height="941.000000pt" viewBox="0 0 2772.000000 941.000000" preserveAspectRatio="xMidYMid meet">
  <g transform="translate(0.000000,941.000000) scale(0.100000,-0.100000)" fill="#000000" stroke="none">
    <path d="M0 4705 l0 -4705 13860 0 13860 0 0 4705 0 4705 -13860 0 -13860 0 0 -4705z m5135 2980 c568 -60 1086 -270 1545 -626 131 -101 363 -331 476 -469 198 -245 383 -568 488 -855 328 -890 214 -1891 -305 -2679 -122 -186 -231 -320 -393 -482 -449 -449 -1000 -735 -1620 -839 -753 -126 -1526 36 -2151 453 -204 136 -294 210 -471 387 -243 241 -404 461 -552 752 -212 418 -313 811 -329 1283 -46 1409 910 2665 2287 3004 118 30 354 69 475 79 111 10 425 5 550 -8z"/>
    <path d="M4590 7180 c-873 -91 -1615 -605 -2000 -1385 -121 -245 -194 -480 -237 -762 -20 -134 -23 -497 -5 -633 108 -818 570 -1497 1287 -1893 360 -199 761 -300 1185 -300 545 0 1040 160 1472 476 543 397 897 982 1000 1652 28 185 30 512 5 690 -159 1112 -1010 1972 -2117 2140 -124 19 -469 27 -590 15z m143 -386 c4 -56 2 -126 -5 -169 l-11 -74 -46 -6 c-152 -19 -275 -42 -378 -71 -22 -6 -29 12 -108 273 l-13 43 67 20 c112 34 345 74 457 79 l31 1 6 -96z m394 71 c102 -14 311 -61 332 -74 8 -5 -2 -52 -35 -157 -25 -82 -49 -152 -53 -155 -3 -4 -55 6 -116 21 -60 15 -158 33 -216 40 l-106 13 -12 83 c-7 48 -9 116 -5 163 l7 81 51 0 c28 0 97 -7 153 -15z m-178 -867 c1 -16 -11 -18 -124 -18 -117 0 -125 1 -125 19 0 16 31 233 121 849 1 9 128 -827 128 -850z m-891 570 c34 -83 61 -152 59 -153 -1 -1 -45 -22 -97 -47 -52 -26 -143 -78 -202 -117 -59 -39 -109 -71 -111 -71 -13 0 -198 253 -194 265 14 36 424 275 471 275 7 0 40 -68 74 -152z m1746 84 c85 -43 249 -145 329 -203 14 -10 -192 -270 -207 -262 -6 5 -47 32 -91 62 -69 47 -254 150 -293 162 -9 3 6 49 50 157 72 176 49 167 212 84z m-2247 -549 l25 -33 -89 -94 c-49 -52 -116 -132 -148 -179 -33 -48 -63 -86 -67 -86 -11 -1 -278 170 -278 178 0 12 99 152 149 211 25 30 82 93 126 139 l80 83 88 -93 c49 -52 100 -109 114 -126z m-500 -461 l141 -73 -39 -84 c-41 -87 -102 -263 -114 -328 -4 -20 -10 -37 -14 -37 -18 0 -312 68 -318 73 -24 25 161 533 191 525 6 -2 75 -36 153 -76z m-194 -661 c76 -10 139 -20 141 -22 1 -2 -2 -58 -8 -123 -6 -80 -6 -158 1 -235 6 -64 10 -117 9 -118 -3 -4 -328 -44 -332 -40 -10 9 -24 286 -19 357 15 207 14 200 43 200 15 0 89 -9 165 -19z m2023 -157 c91 -43 110 -157 39 -228 -69 -70 -182 -51 -224 38 -26 53 -26 69 0 122 14 30 32 48 62 63 51 25 78 26 123 5z m-1841 -540 c11 -61 63 -210 107 -310 24 -55 37 -98 32 -103 -5 -4 -71 -40 -147 -80 l-138 -72 -48 103 c-67 141 -157 419 -140 431 7 6 283 65 305 66 17 1 23 -7 29 -35z m1145 -1009 l0 -125 -130 0 -130 0 0 125 0 125 130 0 130 0 0 -125z m510 0 l0 -125 -130 0 -130 0 0 125 0 125 130 0 130 0 0 -125z m500 0 l0 -125 -125 0 -125 0 0 125 0 125 125 0 125 0 0 -125z m510 0 l0 -125 -125 0 -125 0 0 125 0 125 125 0 125 0 0 -125z"/>
  </g>
</svg>
EOF
}
