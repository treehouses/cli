#!/bin/bash

# create service directory
mkdir -p /srv/mastodon

# create yml(s)
{
  echo "version: \"2\""
  echo "services:"
  echo "  db:"
  echo "    restart: always"
  echo "    image: postgres:9.6.16-alpine"
  echo "    container_name: mastodon-db"
  echo "  redis:"
  echo "    restart: always"
  echo "    image: redis"
  echo "    container_name: mastodon-redis"
  echo "    command: redis-server --appendonly yes"
  echo "  web:"
  echo "    restart: always"
  echo "    image: gilir/rpi-mastodon"
  echo "    container_name: mastodon-web"
  echo "    env_file: .env.production"
  echo "    ports:"
  echo "      - \"3000:3000\""
  echo "      - \"4000:4000\""
  echo "    depends_on:"
  echo "      - db"
  echo "      - redis"
  echo "    environment:"
  echo "      - WEB_CONCURRENCY=1"
  echo "      - MAX_THREADS=5"
  echo "      - SIDEKIQ_WORKERS=5"
  echo "      - RUN_DB_MIGRATIONS=true"
} > /srv/mastodon/mastodon.yml

{
  echo "REDIS_HOST=redis"
  echo "REDIS_PORT=6379"
  echo "DB_HOST=db"
  echo "DB_USER=postgres"
  echo "DB_NAME=postgres"
  echo "DB_PASS="
  echo "DB_PORT=5432"
  echo "LOCAL_DOMAIN=example.com"
  echo "LOCAL_HTTPS=false"
  echo "PAPERCLIP_SECRET=6fd126146f15bed9f5ead7ec2d2e69c298775ecd026171696311e6dcfc776c25279ebb2023f8fade6aa402d7ed9ae35a6c14bb07fced07d6605a27f6502f50a6"
  echo "SECRET_KEY_BASE=7524b29eef74b9608ae95301670fd1d749319d2f2e0e24a6d09fcdeb9ca052c391d7e179767d81fb97c40fab4e4843bf128199ffd9183d3dd14a874bab5eac6a"
  echo "OTP_SECRET=ef090617d612d9fdc497434459f530578ab18123334e9ad8dab0d23ead09097193074ce022d1ec497a4a4d0312c97051627a681374c022613dfe55c82effc325"
  echo "SMTP_SERVER=smtp.mailgun.org"
  echo "SMTP_PORT=587"
  echo "SMTP_LOGIN="
  echo "SMTP_PASSWORD="
  echo "SMTP_FROM_ADDRESS=notifications@example.com"
  echo "STREAMING_CLUSTER_NUM=1"
} > /srv/mastodon/.env.production

# add autorun
{
  echo "mastodon_autorun=true"
  echo
  echo "if [ \"\$mastodon_autorun\" = true ]; then"
  echo "  docker-compose -f /srv/mastodon/mastodon.yml -p mastodon up -d"
  echo "fi"
  echo
  echo
} > /srv/mastodon/autorun

# add port(s)
function get_ports {
  echo "3000"
  echo "4000"
}

# add size (in MB)
function get_size {
  echo "1000"
}

# add info
function get_info {
  echo "https://github.com/gilir/rpi-mastodon, https://github.com/tootsuite/mastodon"
  echo                 
  echo "\"Mastodon is a free, open-source social network server, a decentralized solution to"
  echo "commercial platforms. It avoids the risks of a single company monopolizing your"
  echo "communication. Anyone can run Mastodon and participate in the social network seamlessly.\""
}
