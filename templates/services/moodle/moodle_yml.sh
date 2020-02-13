#!/bin/bash

# create moodle.yml
mkdir -p /srv/moodle
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
