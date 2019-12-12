nextcloud_autorun=true

if [ "$nextcloud_autorun" = true ]; then
  docker run --name nextcloud -d -p 8080:80 nextcloud
fi

