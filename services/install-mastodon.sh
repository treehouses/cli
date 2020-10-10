#!/bin/bash

function install {
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
    echo "  treehouses services mastodon up"
    echo "fi"
    echo
    echo
  } > /srv/mastodon/autorun
}

# environment var
function uses_env {
  echo false
}

# add supported arm(s)
function supported_arms {
  echo "armv7l"
}

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

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="61.076954mm" height="65.47831mm" viewBox="0 0 216.4144 232.00976">
  <path fill="#2b90d9" d="M211.80734 139.0875c-3.18125 16.36625-28.4925 34.2775-57.5625 37.74875-15.15875 1.80875-30.08375 3.47125-45.99875 2.74125-26.0275-1.1925-46.565-6.2125-46.565-6.2125 0 2.53375.15625 4.94625.46875 7.2025 3.38375 25.68625 25.47 27.225 46.39125 27.9425 21.11625.7225 39.91875-5.20625 39.91875-5.20625l.8675 19.09s-14.77 7.93125-41.08125 9.39c-14.50875.7975-32.52375-.365-53.50625-5.91875C9.23234 213.82 1.40609 165.31125.20859 116.09125c-.365-14.61375-.14-28.39375-.14-39.91875 0-50.33 32.97625-65.0825 32.97625-65.0825C49.67234 3.45375 78.20359.2425 107.86484 0h.72875c29.66125.2425 58.21125 3.45375 74.8375 11.09 0 0 32.975 14.7525 32.975 65.0825 0 0 .41375 37.13375-4.59875 62.915"/>
  <path fill="#fff" d="M177.50984 80.077v60.94125h-24.14375v-59.15c0-12.46875-5.24625-18.7975-15.74-18.7975-11.6025 0-17.4175 7.5075-17.4175 22.3525v32.37625H96.20734V85.42325c0-14.845-5.81625-22.3525-17.41875-22.3525-10.49375 0-15.74 6.32875-15.74 18.7975v59.15H38.90484V80.077c0-12.455 3.17125-22.3525 9.54125-29.675 6.56875-7.3225 15.17125-11.07625 25.85-11.07625 12.355 0 21.71125 4.74875 27.8975 14.2475l6.01375 10.08125 6.015-10.08125c6.185-9.49875 15.54125-14.2475 27.8975-14.2475 10.6775 0 19.28 3.75375 25.85 11.07625 6.36875 7.3225 9.54 17.22 9.54 29.675"/>
</svg>
EOF
}
