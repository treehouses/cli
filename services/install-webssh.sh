#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/webssh

  # create yml(s)
  cat << EOF > /srv/webssh/webssh.yml
version: '3'
services:
  webssh:
    image: treehouses/webssh
    ports:
    - "8888:8888"
EOF

  # create .env with default values
#  {
#    echo "EXAMPLE_VAR="
#  } > /srv/<service>/.env

  # add autorun
  cat << EOF > /srv/webssh/autorun
webssh_autorun=true

if [ "$webssh_autorun" = true ]; then
  treehouses services webssh up
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
  echo "armv6l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "8888"
}

# add size (in MB)
function get_size {
  echo "122"
}

# add info
function get_info {
  echo "https://github.com/treehouses/webssh"
  echo
  echo "\"A simple web application to be used as an ssh client to connect to your ssh servers. It is written in Python, base on tornado, paramiko and xterm.js.\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512"><path d="M257.981 272.971L63.638 467.314c-9.373 9.373-24.569 9.373-33.941 0L7.029 444.647c-9.357-9.357-9.375-24.522-.04-33.901L161.011 256 6.99 101.255c-9.335-9.379-9.317-24.544.04-33.901l22.667-22.667c9.373-9.373 24.569-9.373 33.941 0L257.981 239.03c9.373 9.372 9.373 24.568 0 33.941zM640 456v-32c0-13.255-10.745-24-24-24H312c-13.255 0-24 10.745-24 24v32c0 13.255 10.745 24 24 24h304c13.255 0 24-10.745 24-24z"/></svg>
EOF
}