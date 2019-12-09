kolibri_autorun=false

if [ "$kolibri_autorun" = true ]; then
  docker-compose -f /srv/kolibri/kolibri.yml -p kolibri up -d
fi
