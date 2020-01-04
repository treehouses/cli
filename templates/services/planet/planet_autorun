planet_autorun=true

if [ "$planet_autorun" = true ]; then
  if [ -f /srv/planet/pwd/credentials.yml ]; then
    docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -f /srv/planet/pwd/credentials.yml -p planet up -d
  else
    docker-compose -f /srv/planet/planet.yml -f /srv/planet/volumes.yml -p planet up -d
  fi
fi

