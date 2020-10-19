#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/grocy

  # create yml(s)
  cat << EOF > /srv/grocy/grocy.yml
version: "2.1"
services:
  grocy:
    image: linuxserver/grocy
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - PASSWORD=\${PASSWORD}
      - DB_TYPE=\${DB_TYPE}
      - DB_NAME=\${DB_NAME}
      - DB_HOSTNAME=\${DB_HOSTNAME}
      - DB_USERNAME=\${DB_USERNAME}
      - DB_PASSWORD=\${DB_PASSWORD}
    volumes:
      - "/srv/grocy:/root/.grocy"
    ports:
      - 8091:80
    restart: unless-stopped
EOF

  # create .env with default values
  cat << EOF > /srv/grocy/.env
PASSWORD=PASSWORD
DB_TYPE=sqlite
DB_NAME=DB_NAME
DB_HOSTNAME=DB_HOSTNAME
DB_USERNAME=DB_USERNAME
DB_PASSWORD=DB_PASSWORD
EOF

  # add autorun
  cat << EOF > /srv/grocy/autorun
grocy_autorun=true
if [ "$grocy_autorun" = true ]; then
  treehouses services grocy up
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
  echo "8091"
}

# add size (in MB)
function get_size {
  echo "55"
}

# add description
function get_description {
  echo "Grocy is web-based, self-hosted groceries and household management utility for your home"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-grocy"
  echo
  echo "grocy is an enterprise resource planning system for your kitchen."
  echo "Cut down on food waste, manage your chores, keep track of your purchases,"
  echo "and what batteries need charging with this tool."
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" version="1.0" viewBox="0 0 242 93">
  <defs/>
  <path fill="#0b024c" d="M16.5 2.5C11.3 4.3 5.6 10.7 3.3 17.3c-1.4 3.9-1.8 8.2-1.8 17.2 0 10.4.3 12.7 2.3 17C8.1 60.9 15.2 65.9 24.3 66c5.9 0 11.2-2.1 15.6-6.3l3.3-3.2-.7 7.5c-1 9.6-1.7 11.6-5.7 14-4.3 2.6-13 2.6-23.3 0-4.3-1.1-8-2-8.2-2-.2 0-.3 3-.1 6.7l.3 6.8 5 1.3c2.8.8 10 1.4 16 1.5 12.1.1 18.3-1.4 24.4-6 3.6-2.8 8.1-11.2 8.1-15.5 0-5.4.6-5.8 9-5.8h7.8l.4-19.3c.3-18 .4-19.4 2.5-22.3 2-2.8 9.9-7.2 11-6.1.2.3-.1 2.4-.6 4.8-.6 2.4-1.1 7.9-1.1 12.1 0 13.7 5.3 23.3 15.8 28.5 5 2.4 6.9 2.8 14.7 2.8 10.7 0 15.8-2 21.9-8.3l4-4.1 2.3 3.4c1.3 2 4.6 4.5 8 6.2 5.1 2.5 6.9 2.8 15.3 2.8 6.8 0 10.8-.5 14.3-1.8l4.7-1.9V47l-4.2 2.1c-5.8 3-15.4 3.7-19.7 1.5-8.5-4.4-9.8-25-2.1-32.8 2.4-2.4 3.6-2.8 8.4-2.8 9.9 0 9.2-.9 20 26l9.7 24.2-2.3 4.6c-3.2 6.5-6.7 8.7-13.4 8.7H180v13.3l4.5.6c10.8 1.7 21.5-3.4 26.9-12.8 2-3.3 29.6-75.4 29.6-77.1 0-.3-4-.5-8.9-.5h-9l-6.4 19.7c-3.5 10.9-6.9 21.4-7.5 23.3-1 3.4-1 3.4-1.1.7-.1-1.6-3.1-12-6.8-23.2l-6.6-20.2-14.3-.8c-11.6-.5-15.4-.4-19.7.9-6.1 1.8-12.6 6.1-14.5 9.8l-1.4 2.5-5.2-5.3c-4-3.9-6.7-5.6-10.6-6.8-8.7-2.6-18.1-1.9-27.2 1.9-1.4.5-1.8.2-1.8-1.4 0-1.9-.6-2.1-5.2-2.1-6.4 0-12.9 3-16.4 7.6-1.5 1.9-3 3.4-3.4 3.4-.4 0-1.3-2.3-2-5l-1.2-5H45.2l-.7 4-.7 4-3.6-3.1C33.5 1 25.2-.6 16.5 2.5zm20.6 14.1c4.5 2.3 6.2 7.2 6.2 18 .1 11.2-1.8 15.2-7.9 17.2-12.5 4.2-20.1-8-16.3-26 2.1-9.6 9.7-13.5 18-9.2zm88.8 1c4 3.3 5.4 8.9 4.9 18.4-.7 11.8-4.1 16-13.1 16-8.7 0-12.1-5.3-12.1-18.5C105.6 20 109 15 118.1 15c3.6 0 5.5.6 7.8 2.6z"/>
</svg>
EOF
}
