#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/ntopng

  # create yml(s)
  {
    echo "services:"
    echo "  ntopng:"
    echo "    image: jonbackhaus/ntopng"
    echo "    ports:"
    echo "      - \"8084:3000\""
    echo "    volumes:"
    echo "      - \"/var/run/docker.sock:/var/run/docker.sock\""
    echo "version: \"2\""
  } > /srv/ntopng/ntopng.yml

  # add autorun
  {
    echo "ntopng_autorun=true"
    echo
    echo "if [ \"\$ntopng_autorun\" = true ]; then"
    echo "  docker volume create ntopng_data"
    echo "  docker run --name ntopng -d -p 8090:8090 -v /var/run/docker.sock:/var/run/docker.sock -v ntopng_data:/data jonbackhaus/ntopng --http-port=8090"
    echo "fi"
    echo
    echo
  } > /srv/ntopng/autorun
}

# add port(s)
function get_ports {
  echo "8084"
}

# add size (in MB)
function get_size {
  echo "400"
}

# add info
function get_info {
  echo "https://github.com/ntop/ntopng"
  echo                 
  echo "\"ntopng is the next generation version of the original ntop,"
  echo "a network traffic probe that monitors network usage. ntopng is"
  echo "based on libpcap and it has been written in a portable way in order"
  echo "to virtually run on every Unix platform, MacOSX and on Windows as well."
  echo "Educational users can obtain commercial products at no cost please see here:"
  echo "https://www.ntop.org/support/faq/do-you-charge-universities-no-profit-and-research/\""
}
