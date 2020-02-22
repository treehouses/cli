#!/bin/bash

mkdir -p /srv/ntopng

# create ntopng.yml
{
  echo "services:"
  echo "  ntopng:"
  echo "    image: jonbackhaus/ntopng"
  echo "    ports:"
  echo "      - \"8090:8090\""
  echo "    volumes:"
  echo "      - \"/var/run/docker.sock:/var/run/docker.sock\""
  echo "      - \"/ntopng_data:/data_jonbackhaus/ntopng\""
  echo "version: \"2\""
} > /srv/ntopng/ntopng.yml
