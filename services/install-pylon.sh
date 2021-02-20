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
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - PYUSER=\${PYUSER}
      - PYPASS=\${PYPASS}
    ports:
      - 8095:3131
    restart: unless-stopped
EOF

  # create .env with default values
  cat << EOF > /srv/pylon/.env
PYUSER=<username>
PYPASS=<password>
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

# add supported arch(es)
function supported_arches {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "8095"
}

 #add size (in MB)
function get_size {
  echo "255"
}

# add description
function get_description {
  echo "Pylon is a web based integrated development environment built with Node.js as a backend"
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
<svg xmlns="http://www.w3.org/2000/svg" version="1.0" viewBox="0 0 262 192">
  <defs/>
  <path d="M0 96v96h262V0H0v96zm137.7-74.6c7.3 3.4 10.6 8.7 11.1 17.5.3 6.4.2 7-5.3 17.6-3.2 6-6.3 11.9-7.1 12.9-1.3 1.9-.7 2.4 9.2 7.9 12.5 7 15.8 7.8 19.7 4.7 3.3-2.6 3.7-8.5.8-12.1-3.6-4.5-14.1-2.1-14.1 3.1 0 .9-.3 1.9-.6 2.3-1.1 1.1-11.4-4.6-11.4-6.4 0-.9 1.3-3.5 3-5.7 7.5-10.4 23.2-11.7 32.3-2.6 4.6 4.6 6 9 5.5 16.9-.7 11.8-8.4 18.9-20.3 18.9-6.7.1-6.2.3-43.9-20.4-20.3-11.2-23.8-12.2-27.7-8.3-3.2 3.2-3 9 .5 11.9 1.5 1.3 4 2.4 5.5 2.4 3.4 0 8.1-3.5 8.1-6 0-3.1 1.3-3 6.8.2 4.4 2.5 5.2 3.3 4.6 5.2-2.9 9.3-14.1 15.2-24.5 12.8-10.3-2.4-16.2-9.9-16.2-20.4 0-12.3 8.5-21.1 20.3-21.1 5.2 0 7.2.6 17.8 6.1 9 4.6 12.3 5.8 13 4.9.5-.7 3.2-5.5 6.1-10.8 6-11.3 6.6-15.6 2.5-18.8-3.6-2.8-7.9-2.7-10.9.4-4.6 4.5-2.6 12.6 3.5 14.2l2.9.8-3.2 5.8-3.3 5.7-4.5-2.3c-10.1-5.4-13.7-17.4-8.5-28.1 5.2-10.6 17.1-14.4 28.3-9.2zM44.2 118c4.4 1.3 9.3 5.2 11.3 9.1 2.3 4.3 1.9 4.9-3.1 4.9-3.8 0-5.1-.5-7.4-3-3.9-4.2-9-4.2-13.2 0-2.8 2.8-3 3.5-2.6 8.2.4 4 1.2 5.7 3.2 7.5 4 3.4 9 3.1 12.6-.7 2.3-2.5 3.6-3 7.4-3 3 0 4.6.4 4.6 1.2 0 2.6-4.1 7.8-8.1 10.5-8.1 5.3-20.2 3-26-5-5.4-7.4-4.8-17.6 1.4-24.3 5.1-5.5 12.4-7.5 19.9-5.4zM71 132v15h12.1l-.3 4.2-.3 4.3-10.7.3-10.8.3V117h10v15zm38.3-13.9c4.7 1.3 10.6 6.3 12.3 10.6 1.6 3.7 1.8 11.1.5 14.6-3.3 8.6-14.1 14.2-22.9 11.8-12.4-3.3-18.5-15.5-13.3-26.6 4.2-9.1 13.4-13.2 23.4-10.4zm27.5 12.8c.1 7.9.7 14 1.4 14.8.7.8 3.5 1.3 7.9 1.3h6.9v-30h9l-.2 19.2-.3 19.3H149c-21.5 0-22.4-1.3-22.1-31.8l.1-6.8 4.8.3 4.7.3.3 13.4zm54.2-11.2c9.8 6.1 11.7 22.6 3.4 30.8-4 4.1-10.8 5.8-20.9 5.3l-7-.3-.3-18c-.1-9.8 0-18.6.3-19.3.4-1.1 2.7-1.3 10.8-1 8.3.3 10.9.7 13.7 2.5zm41.7.2c7.7 3.5 12 13.4 9.3 21.7-.7 2.2-4.6 10.1-8.7 17.6l-7.5 13.8h-6.4c-3.5 0-6.4-.2-6.4-.5s4.1-7.9 9-16.8c5-9 9-17.3 9-18.6 0-5.5-4.6-8.8-9.9-7-6 2.1-6.5 10.7-.7 13.6 1.7.8 3.2 1.7 3.4 1.8.6.5-5.1 9.5-6.2 9.5-2.5 0-8.7-5.3-10.6-9-2.2-4.3-2.7-12.1-.9-16.7 1.4-3.7 5.7-8.2 9.4-9.9 4.3-1.9 12.3-1.7 17.2.5z"/>
  <path d="M96.9 128.9c-6.4 6.4-2.1 18.1 6.6 18.1 2.7 0 4.4-.8 6.6-2.9 6.4-6.4 2.1-18.1-6.6-18.1-2.7 0-4.4.8-6.6 2.9zm79.1 7.6V147h2.9c5.1 0 8.1-1.8 9.7-5.7 3.2-7.6-1.1-15.3-8.6-15.3h-4v10.5z"/>
</svg>
EOF
}
