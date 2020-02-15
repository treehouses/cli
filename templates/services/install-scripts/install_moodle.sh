#!/bin/bash

# create service directory
mkdir -p /srv/moodle

# create yml(s)
{
  echo "version: '2'"
  echo "services:"
  echo "  moodledb_rpi:"
  echo "    image: arm32v7/postgres:11"
  echo "    container_name: moodledb_rpi"
  echo "    environment:"
  echo "    # MAKE SURE THIS ONE SAME WITH THE MOODLE"
  echo "    - POSTGRES_DATABASE=moodle"
  echo "    - POSTGRES_USER=moodle"
  echo "    - POSTGRES_PASSWORD=moodle"
  echo "  moodle_rpi:"
  echo "    image: treehouses/moodle:rpi-latest"
  echo "    container_name: moodle_rpi"
  echo "    ports:"
  echo "      - \"8082:80\""
  echo "    environment:"
  echo "    - MOODOLE_DB_URL=moodledb_rpi"
  echo "    - MOODOLE_DB_NAME=moodle"
  echo "    - MOODOLE_DB_USER=moodle"
  echo "    - MOODOLE_DB_PASS=moodle"
  echo "    - MOODOLE_DB_PORT=5432"
  echo "    - MOODOLE_MAX_BODY_SIZE=200M"
  echo "    - MOODOLE_BODY_TIMEOUT=300s"
} > /srv/moodle/moodle.yml

# add port(s)
{
  echo "8082"
} > /srv/moodle/ports

# add size (in MB)
{
  echo "350"
} > /srv/moodle/size

# add info
{
  echo "https://github.com/treehouses/moodole"
  echo
  echo "\"Moodle <https://moodle.org> is a learning platform designed to"
  echo "provide educators, administrators and learners with a single robust,"
  echo "secure and integrated system to create personalised learning"
  echo "environments.\""
} > /srv/moodle/info

# add autorun
{
  echo "moodle_autorun=true"
  echo
  echo "if [ \"$moodle_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/moodle/moodle.yml -p moodle up -d"
  echo "fi"
  echo
  echo
} > /srv/moodle/autorun
