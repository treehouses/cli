#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/novnc

  # create yml(s)
  cat << EOF > /srv/novnc/novnc.yml
version: '3'
services:
  novnc:
    image: treehouses/novnc
    ports:
    - "6080:6080"
EOF

  # create .env with default values
  # {
  #  echo "EXAMPLE_VAR="
  # } > /srv/<service>/.env

  # add autorun
  cat << EOF > /srv/novnc/autorun
novnc_autorun=true

if [ "$novnc_autorun" = true ]; then
  treehouses services novnc up
fi


EOF
}

# environment var
function uses_env {
  echo false
}

# add supported arch(es)
function supported_arms {
  echo "armv7l"
  echo "armv6l"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "6080"
}

# add size (in MB)
function get_size {
  echo "133"
}

# add info
function get_info {
  echo "https://github.com/treehouses/novnc"
  echo
  echo "\"noVNC is both a HTML VNC client JavaScript library and an application built on top of that library. noVNC runs well in any modern browser including mobile browsers (iOS and Android).\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg>
</svg>
EOF
}
