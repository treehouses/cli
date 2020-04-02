#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/privatebin

  # create yml(s)
  {
    echo "version: \"3\""
    echo
    echo "services:"
    echo "  privatebin:"
    echo "    container_name: privatebin"
    echo "    image: treehouses/privatebin"
    echo "    ports:"
    echo "      - \"8083:80\""
  } > /srv/privatebin/privatebin.yml

  # add autorun
  {
    echo "privatebin_autorun=true"
    echo
    echo "if [ \"\$privatebin_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/privatebin/privatebin.yml -p privatebin up -d"
    echo "fi"
    echo
    echo
  } > /srv/privatebin/autorun
}

# add port(s)
function get_ports {
  echo "8083"
}

# add size (in MB)
function get_size {
  echo "550"
}

# add info
function get_info {
  echo "https://github.com/treehouses/privatebin"
  echo
  echo "\"A minimalist, open source online pastebin where the server has"
  echo "zero knowledge of pasted data. Data is encrypted/decrypted in the"
  echo "browser using 256 bits AES. https://privatebin.info/\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns="http://www.w3.org/2000/svg" height="38" width="38" version="1.1" xmlns:cc="http://creativecommons.org/ns#" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 38 38" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <defs><radialGradient id="a" gradientUnits="userSpaceOnUse" cx="261" cy="240" r="341" gradientTransform="matrix(1.3 .000949 -.00102 1.4 -89.2 -86.2)">
    <stop stop-color="#ff0" offset="0"/>
    <stop stop-color="#fa0" offset="1"/>
  </radialGradient></defs>
  <path stroke-linejoin="round" d="m250 3.16-227 123-0.42 247 227 124 227-123 0.42-247zm-0.711 97.9v0.006c3.78 0 7.6 0.297 11.5 0.875 41.1 6.17 72.2 40.6 66.4 70.5-5.8 29.8-33.3 56-40.1 61.7s37.1 165 37.1 165h-149s46.2-157 36.5-165c-9.7-8.14-41.2-36.9-36.4-68.9 4.81-32.1 37.6-64 74.2-64.1z" transform="matrix(.0709 0 0 .0709 1.4 1.38)" stroke="#000" stroke-linecap="round" stroke-width="10.6" fill="url(#a)"/>
</svg>
EOF
}
