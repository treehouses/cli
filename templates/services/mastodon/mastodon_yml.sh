#!/bin/bash

#create mastodon.yml
mkdir -p /srv/mastodon/

cat >/srv/mastodon/mastodon.yml <<EOF1
version: '2'
services:
  db:
    restart: always
    image: postgres:9.6.16-alpine
    container_name: mastodon-db
#    ports:
#      - "5432:5432"

  redis:
    restart: always
    image: redis
    container_name: mastodon-redis
    command: redis-server --appendonly yes

  web:
    restart: always
    build: .
    image: gilir/rpi-mastodon
    container_name: mastodon-web
    env_file: .env.production
    ports:
      - "3000:3000"
      - "4000:4000"
    depends_on:
      - db
      - redis
    environment:
      - WEB_CONCURRENCY=1
      - MAX_THREADS=5
      - SIDEKIQ_WORKERS=5
      - RUN_DB_MIGRATIONS=true

EOF1

cat > /srv/mastodon/.env.production <<EOF2
REDIS_HOST=redis
REDIS_PORT=6379
DB_HOST=db
DB_USER=postgres
DB_NAME=postgres
DB_PASS=
DB_PORT=5432
LOCAL_DOMAIN=example.com
LOCAL_HTTPS=false
PAPERCLIP_SECRET=6fd126146f15bed9f5ead7ec2d2e69c298775ecd026171696311e6dcfc776c25279ebb2023f8fade6aa402d7ed9ae35a6c14bb07fced07d6605a27f6502f50a6
SECRET_KEY_BASE=7524b29eef74b9608ae95301670fd1d749319d2f2e0e24a6d09fcdeb9ca052c391d7e179767d81fb97c40fab4e4843bf128199ffd9183d3dd14a874bab5eac6a
OTP_SECRET=ef090617d612d9fdc497434459f530578ab18123334e9ad8dab0d23ead09097193074ce022d1ec497a4a4d0312c97051627a681374c022613dfe55c82effc325
SMTP_SERVER=smtp.mailgun.org
SMTP_PORT=587
SMTP_LOGIN=
SMTP_PASSWORD=
SMTP_FROM_ADDRESS=notifications@example.com
STREAMING_CLUSTER_NUM=1
EOF2
