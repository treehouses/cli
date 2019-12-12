nextcloud_autorun=true

if [ "$nextcloud_autorun" = true ]; then
  docker run --name nextcloud -d -p 8081:80 nextcloud
fi

