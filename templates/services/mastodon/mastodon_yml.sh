#!/bin/bash

#create mastodon.yml
mkdir -p /srv/mastodon/
mkdir -p /home/pi/mastodon/public/packs
mkdir -p /home/pi/mastodon/public/system
mkdir -p /home/pi/mastodon/public/assets
{
#  echo "services:"
  echo "mastodon:"
  echo "  image: gilir/rpi-mastodon"
  echo "  restart: always"
#  echo "    ports:"
#  echo "      - 3000:3000"
#  echo "      - 4000:4000"
  echo "  container_name: mastodon"
  echo "  env_file: /home/pi/mastodon/.env.production"
  echo "  environment:"
  echo "    - WEB_CONCURRENCY=16"
  echo "    - MAX_THREADS=20"
  echo "    - SIDEKIQ_WORKERS=25"
  echo "    - RUN_DB_MIGRATIONS=true"
#  echo "  links:"
#  echo "    - mastodon-pgb"
#  echo "    - mastodon-redis"
  echo "  volumes:"
  echo "    - /home/pi/mastodon/public/system:/mastodon/public/system"
  echo "    - /home/pi/mastodon/public/assets:/mastodon/public/assets"
  echo "    - /home/pi/mastodon/public/packs:/mastodon/public/packs"
  #echo "  - /home/docker/mastodon/public/system:/mastodon/public/system"
  #echo "  - /home/docker/mastodon/public/assets:/mastodon/public/assets"
  #echo "  - /home/docker/mastodon/public/packs:/mastodon/public/packs"
} > /srv/mastodon/mastodon.yml
