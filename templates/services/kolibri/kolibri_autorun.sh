#!/bin/bash

# create autorun
{
  echo "#!/bin/bash"
  echo
  echo "sleep 1"
  echo
  echo "docker-compose -f /srv/kolibri/kolibri.yml -p kolibri up -d"
} > /boot/autorun
