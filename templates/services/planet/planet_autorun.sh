#!/bin/bash

# create autorun
{
  echo "#!/bin/bash"
  echo
  echo "sleep 1"
  echo
  echo "if [ -f /srv/planet/pwd/credentials.yml ]; then"
  echo "  docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d"
  echo "else"
  echo "  docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d"
  echo "fi"
} > /boot/autorun
