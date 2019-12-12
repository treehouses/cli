nextcloud_autorun=true

if [ "$nextcloud_autorun" = true ]; then
  docker start nextcloud
fi

