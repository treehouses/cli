#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/bookstack

  # create yml(s)
  cat << EOF > /srv/bookstack/bookstack.yml
version: "2"
services:
  bookstack:
    image: linuxserver/bookstack
    environment:
      - PUID=\${PUID}
      - PGID=\${PGID}
      - DB_HOST=bookstack_db
      - DB_USER=\${DB_USERNAME}
      - DB_PASS=\${DB_PASSWORD}
      - DB_DATABASE=\${DB_DATABASE}
    volumes:
      - /srv/bookstack:/root/.bookstack
    ports:
      - 8092:80
    restart: unless-stopped
    depends_on:
      - bookstack_db
  bookstack_db:
    image: linuxserver/mariadb
    environment:
      - PUID=\${PUID}
      - PGID=\${PGID}
      - MYSQL_ROOT_PASSWORD=\${DB_PASSWORD}
      - TZ=Europe/London
      - MYSQL_DATABASE=\${DB_DATABASE}
      - MYSQL_USER=\${DB_USERNAME}
      - MYSQL_PASSWORD=\${DB_PASSWORD}
    volumes:
      - /srv/bookstack:/root/.bookstack
    restart: unless-stopped
EOF

  # create .env with default values
  cat << EOF > /srv/bookstack/.env
PUID=1000
PGID=1000
DB_USERNAME=db_username
DB_PASSWORD=db_password 
DB_DATABASE=bookstackapp
EOF

  # add autorun
  cat << EOF > /srv/bookstack/autorun
bookstack_autorun=true

if [ "$bookstack_autorun" = true ]; then
  treehouses services bookstack up
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
  echo "8092"
}

# add size (in MB)
function get_size {
  echo "308"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-bookstack"
  echo
  echo "Bookstack is a free and open source Wiki designed for creating beautiful documentation"
  echo "It featrues a simple, but powerful WYSIWYG editor that allows teams to create detailed and useful documentation with ease."
  echo "The default username is admin@admin.com with the password of password."
}

# add svg icon
function get_icon {
  cat <<EOF
<svg id="svg4200" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://www.w3.org/2000/svg" height="61.699mm" width="65.023mm" version="1.1" xmlns:cc="http://creativecommons.org/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" viewBox="0 0 230.39711 218.6199">
 <g id="layer1" stroke-linejoin="round" fill-rule="evenodd" transform="translate(-245.27 -58.434)" stroke="#0288d1" stroke-width="6" fill="#fff">
  <g stroke-linecap="round">
   <path id="path5686" d="m343.79 238.6 128.88-74.409-92.058-53.15-128.88 74.409z"></path>
   <path id="path5688" d="m251.73 185.45v21.26l92.058 53.15 128.88-74.409v-21.26"></path>
   <path id="path5694" d="m343.79 274.03-92.058-53.15s-7.5-16.918 0-28.346l92.058 53.15 128.88-74.409v28.346l-128.88 74.409"></path>
   <path id="path5686-5" d="m343.79 188.99 128.88-74.41-92.06-53.146-128.88 74.406z"></path>
   <path id="path5692-7" d="m343.79 188.99 128.88-74.409 0.00001 28.346-128.88 74.409-92.058-53.15s-6.0714-17.632 0-28.346z"></path>
   <path id="path5694-5" d="m343.79 245.69-92.058-53.15s-7.5-16.918 0-28.346l92.058 53.15 128.88-74.409-0.00001 28.346-128.88 74.409"></path>
  </g>
  <path id="path5831" d="m402.09 73.836-55.234 31.89 21.48 1.7716 3.0686 12.402 55.235-31.89z"></path>
 </g>
</svg>
EOF
}
