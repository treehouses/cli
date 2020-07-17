#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/webssh

  # create yml(s)
  cat << EOF > /srv/webssh/webssh.yml
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
#function get_icon {
#  cat <<EOF
##<svg icon code>
#EOF
#}