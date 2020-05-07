#!/bin/bash

function install {

  # create yml(s)
  {
    echo "version: '3.6'"
    echo ""
    echo "volumes:"
    echo "  db:"
    echo "  storage:"
    echo "  logo:"
    echo "  public:"
    echo ""
    echo "# uncomment if you want to use external network (example network: \"web\")"
    echo "#networks:"
    echo "#  web:"
    echo "#    external: true"
    echo ""
    echo "services:"
    echo "  db:"
    echo "    image: beercan1989/arm-mysql:5"
    echo "    env_file: .env"
    echo "    restart: always"
    echo "    volumes:"
    echo "      - db:/var/lib/mysql"
    echo "    networks:"
    echo "      - default"
    echo ""
    echo "  app:"
    echo "    image: hirotochigi/invoiceninja_app "
    echo "    env_file: .env"
    echo "    restart: always"
    echo "    depends_on:"
    echo "      - db"
    echo "    volumes:"
    echo "      -  storage:/var/www/app/storage"
    echo "      -  logo:/var/www/app/public/logo"
    echo "      -  public:/var/www/app/public"
    echo "    networks: "
    echo "      - default  "
    echo ""
    echo "  web:"
    echo "    image: nginx:1"
    echo "    volumes:"
    echo "      - ./nginx.conf:/etc/nginx/nginx.conf:ro"
    echo "      -  storage:/var/www/app/storage"
    echo "      -  logo:/var/www/app/public/logo"
    echo "      -  public:/var/www/app/public"
    echo "    expose: "
    echo "      - \"80\""
    echo "    depends_on:"
    echo "      - app"
    echo "    ports: # Delete if you want to use reverse proxy"
    echo "      - 8089:80"
    echo "    networks:"
    echo "#      - web        # uncomment if you want to use  external network (reverse proxy for example)"
    echo "      - default"
    echo ""
    echo "  cron:"
    echo "    image: invoiceninja/invoiceninja"
    echo "    env_file: .env"
    echo "    volumes:"
    echo "      -  storage:/var/www/app/storage"
    echo "      -  logo:/var/www/app/public/logo"
    echo "      -  public:/var/www/app/public"
    echo "    entrypoint: |"
    echo "      bash -c 'bash -s <<EOF"
    echo "      trap \"break;exit\" SIGHUP SIGINT SIGTERM"
    echo "      sleep 300s"
    echo "      while /bin/true; do"
    echo "        ./artisan ninja:send-invoices"
    echo "        ./artisan ninja:send-reminders"
    echo "        sleep 1d"
    echo "      done"
    echo "      EOF'"
    echo "    networks:"
    echo "      - default"
  } > /srv/invoiceninja/invoiceninja.yml

  # create .env with default values
  {
    echo "MYSQL_DATABASE=ninja"
    echo "MYSQL_ROOT_PASSWORD=pwd"
    echo ""
    echo "APP_DEBUG=0"
    echo "APP_URL=http://localhost:8000"
    echo "APP_KEY=SomeRandomStringSomeRandomString"
    echo "APP_CIPHER=AES-256-CBC"
    echo "DB_USERNAME=root"
    echo "DB_PASSWORD=pwd"
    echo "DB_HOST=db"
    echo "DB_DATABASE=ninja"
    echo "MAIL_HOST=mail.service.host"
    echo "MAIL_USERNAME=username"
    echo "MAIL_PASSWORD=password"
    echo "MAIL_DRIVER=smtp"
    echo "MAIL_FROM_NAME=/"My name/""
    echo "MAIL_FROM_ADDRESS=user@mail.com"
  } > /srv/invoiceninja/.env

  # create nginx.conf
  {
    echo "user www-data;"
    echo ""
    echo "events {"
    echo "  worker_connections 768;"
    echo "}"
    echo ""
    echo "http {"
    echo "    upstream backend {"
    echo "        server app:9000;"
    echo "    }"
    echo "    include /etc/nginx/mime.types;"
    echo "    default_type application/octet-stream;"
    echo "    gzip on;"
    echo "    gzip_disable /"msie6/";"
    echo ""
    echo "    server {"
    echo "        listen      80 default;"
    echo "        server_name your_ininja_site;"
    echo ""
    echo "        root /var/www/app/public;"
    echo ""
    echo "        index index.php;"
    echo ""
    echo "        charset utf-8;"
    echo ""
    echo "        location / {"
    echo "            try_files $uri $uri/ /index.php?$query_string;"
    echo "        }"
    echo ""
    echo "        location = /favicon.ico { access_log off; log_not_found off; }"
    echo "        location = /robots.txt  { access_log off; log_not_found off; }"
    echo ""
    echo "        sendfile off;"
    echo ""
    echo "        location ~ \.php$ {"
    echo "            fastcgi_split_path_info ^(.+\.php)(/.+)$;"
    echo "            fastcgi_pass backend;"
    echo "            fastcgi_index index.php;"
    echo "            include fastcgi_params;"
    echo "            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;"
    echo "            fastcgi_intercept_errors off;"
    echo "            fastcgi_buffer_size 16k;"
    echo "            fastcgi_buffers 4 16k;"
    echo "        }"
    echo ""
    echo "        location ~ /\.ht {"
    echo "            deny all;"
    echo "        }"
    echo "    }"
    echo "}"
  } > /srv/invoiceninja/nginx.conf

  # add autorun
  {
    echo "invoiceninja_autorun=true"
    echo
    echo "if [ \"\$invoiceninja_autorun\" = true ]; then"
    echo "  treehouses services invoiceninja up"
    echo "fi"
    echo
    echo
  } > /srv/invoiceninja/autorun
}

# environment var
function uses_env {
  echo true
}

# add supported arm(s)
function supported_arms {
  echo "v7l"
}

# add port(s)
function get_ports {
  echo "8089"
}

# add size (in MB)
function get_size {
  echo "553"
}

# add info
function get_info {
  echo "https://github.com/treehouses/rpi-invoiceninja"
  echo
  echo "\"Seafile is an open source file sync&share solution designed for"
  echo "high reliability, performance and productivity. Sync, share and"
  echo "collaborate across devices and teams. Build your team's knowledge"
  echo "base with Seafile's built-in Wiki feature. https://www.invoiceninja.com/\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" version="1">
 <path style="opacity:0.2" d="m 4.0507995,32.000622 c -0.0118,0.333993 -0.050799,0.661986 -0.050799,0.999979 C 4.0000006,48.512268 16.487733,61 31.9994,61 47.511067,61 59.998799,48.512268 59.998799,33.000601 c 0,-0.337673 -0.03904,-0.665266 -0.05078,-0.999979 -0.527989,15.041677 -12.775726,26.999421 -27.949401,26.999421 -15.174074,0 -27.4214118,-11.957744 -27.9494004,-26.999421 z"/>
 <path style="fill:#fea238" d="m 31.9998,4.0012441 c -15.511667,0 -27.9993994,12.4877319 -27.9993994,27.9993999 0,15.511667 12.4877324,27.999399 27.9993994,27.999399 15.511667,0 27.999399,-12.487732 27.999399,-27.999399 0,-15.511668 -12.487732,-27.9993999 -27.999399,-27.9993999 z"/>
 <path style="opacity:0.2;fill:#ffffff" d="M 32 4.0019531 C 16.488333 4.0019531 4 16.488332 4 32 C 4 32.098348 4.0111933 32.193967 4.0175781 32.291016 C 4.3923697 17.110603 16.726112 5 32 5 C 47.273888 5 59.60763 17.110603 59.982422 32.291016 C 59.988769 32.194031 60 32.098203 60 32 C 60 16.488332 47.511667 4.0019531 32 4.0019531 z"/>
 <path style="opacity:0.2" d="m 26.083984,21.013594 c -0.795565,0.04108 -1.578202,0.192792 -2.039062,0.441406 -1.549607,0.835982 -2.692552,1.933788 -3.015625,3.71875 -0.08484,0.46871 -0.206411,0.907016 -0.269531,0.972656 -0.0631,0.06564 -0.372347,0.0456 -0.6875,-0.04492 -0.730904,-0.209896 -1.777341,0.03358 -2.669922,0.623047 -0.707445,0.46719 -1.364587,2.061289 -1.533203,3.048829 -0.09518,0.557486 -0.128746,0.185546 -0.683594,0.185546 -0.450191,0 -0.652223,0.09234 -0.892578,0.410157 -0.40807,0.539569 -0.390957,0.821472 0.05859,1.289062 0.364194,0.378571 0.395634,0.38326 3.109376,0.380859 1.008929,-8.69e-4 1.770924,-0.02796 2.294921,-0.0625 0.299388,-0.637679 0.690746,-1.244 1.212891,-1.787109 2.224683,-2.314005 5.65475,-2.659911 8.349609,-1.173828 0.672748,-1.178064 1.50757,-2.191639 2.501953,-2.958984 -0.0039,-0.123115 -0.133988,-0.642568 -0.296874,-1.179688 -0.52699,-1.738123 -1.670455,-2.986153 -3.330079,-3.636719 C 27.68657,21.04151 26.87955,20.972512 26.083984,21.013594 Z m 11.861328,4.998047 c -1.588727,-0.02893 -3.228915,0.441077 -4.677734,1.441406 -1.38501,0.956179 -2.366649,2.039968 -2.892578,3.775391 -0.140877,0.46493 -0.319324,0.845703 -0.396484,0.845703 -0.07714,0 -0.369237,-0.510803 -0.650391,-0.767578 -1.995957,-1.82288 -5.01963,-1.705027 -6.917969,0.269531 -1.41265,1.469368 -1.672349,4.036789 -0.953125,5.986328 0.07574,0.205255 -0.600683,0.367803 -1.298828,0.734375 -1.045218,0.548708 -1.723414,1.330156 -1.980469,2.285156 -0.46259,1.717963 0.868033,3.544765 2.683594,4.21875 0.759584,0.282373 2.227162,0.261685 3.101563,-0.04297 0.647986,-0.225795 1.284312,-0.818964 5.173828,-4.830078 5.124091,-5.284367 5.316554,-5.925993 7.412109,-5.933593 1.061118,-0.0039 1.819844,0.05747 2.703125,0.509765 1.201594,0.615386 2.082689,2.090488 2.511719,3.283203 0.399392,1.108976 0.402817,2.458381 0.0098,3.128907 -0.344254,0.587247 -1.592686,1.136718 -2.263672,1.136718 -0.666485,0 -1.7867,-0.58374 -2.058594,-1.179687 C 37.012033,39.853968 36.947506,38.892284 38,37.999922 c -2.086901,0.05366 -2.335914,0.830684 -3,3.216797 0,1.649565 0.836381,3.235112 2.212891,3.658203 0.336193,0.103237 2.21293,0.144741 5.105468,0.113281 4.357726,-0.04738 4.600367,-0.06656 5.171875,-0.388672 0.837782,-0.47225 1.801043,-1.550992 2.177735,-2.439453 0.374532,-0.883381 0.441271,-2.573606 0.148437,-3.503906 -0.553845,-1.625033 -3.106577,-3.377291 -4.722656,-2.277344 -0.282474,0.320715 -0.553476,0.04028 -0.603516,-0.01172 -0.04998,-0.05198 0.221858,-0.297013 0.359375,-0.789063 0.183636,-0.657566 0.234007,-1.312561 0.191407,-2.472656 -0.05422,-1.475448 -0.09787,-1.665769 -0.683594,-2.919922 -1.255973,-2.68928 -3.76423,-4.125617 -6.41211,-4.173828 z"/>
 <path style="fill:#ffffff" d="M 26.083984 20.013672 C 25.288419 20.054754 24.505782 20.206464 24.044922 20.455078 C 22.495315 21.29106 21.35237 22.388866 21.029297 24.173828 C 20.944459 24.642538 20.822886 25.080844 20.759766 25.146484 C 20.696667 25.212121 20.387419 25.192083 20.072266 25.101562 C 19.341362 24.891666 18.294925 25.135142 17.402344 25.724609 C 16.694899 26.191799 16.037757 27.785898 15.869141 28.773438 C 15.773963 29.330924 15.740395 28.958984 15.185547 28.958984 C 14.735356 28.958984 14.533324 29.051327 14.292969 29.369141 C 13.884899 29.90871 13.902012 30.190613 14.351562 30.658203 C 14.715756 31.036774 14.747196 31.041463 17.460938 31.039062 C 18.469867 31.038193 19.231862 31.011098 19.755859 30.976562 C 20.055247 30.338883 20.446605 29.732562 20.96875 29.189453 C 23.193433 26.875448 26.6235 26.529542 29.318359 28.015625 C 29.991107 26.837561 30.825929 25.823986 31.820312 25.056641 C 31.816448 24.933526 31.686324 24.414073 31.523438 23.876953 C 30.996448 22.13883 29.852983 20.8908 28.193359 20.240234 C 27.68657 20.041588 26.87955 19.97259 26.083984 20.013672 z M 37.945312 25.011719 C 36.356585 24.982792 34.716397 25.452796 33.267578 26.453125 C 31.882568 27.409304 30.900929 28.493093 30.375 30.228516 C 30.234123 30.693446 30.055676 31.074219 29.978516 31.074219 C 29.901378 31.074219 29.609279 30.563416 29.328125 30.306641 C 27.332168 28.483761 24.308495 28.601614 22.410156 30.576172 C 20.997506 32.04554 20.737807 34.612961 21.457031 36.5625 C 21.53277 36.767755 20.856348 36.930303 20.158203 37.296875 C 19.112985 37.845583 18.434789 38.627031 18.177734 39.582031 C 17.715144 41.299994 19.045767 43.126796 20.861328 43.800781 C 21.620912 44.083154 23.08849 44.062466 23.962891 43.757812 C 24.610877 43.532017 25.247203 42.938848 29.136719 38.927734 C 34.26081 33.643367 34.453273 33.001741 36.548828 32.994141 C 37.609946 32.990262 38.368672 33.051615 39.251953 33.503906 C 40.453547 34.119292 41.334642 35.594394 41.763672 36.787109 C 42.163064 37.896085 42.166489 39.24549 41.773438 39.916016 C 41.429184 40.503263 40.180752 41.052734 39.509766 41.052734 C 38.843281 41.052734 37.723066 40.468994 37.451172 39.873047 C 37.012033 38.854046 36.947506 37.892362 38 37 C 35.913099 37.053656 35.664086 37.830684 35 40.216797 C 35 41.866362 35.836381 43.451909 37.212891 43.875 C 37.549084 43.978237 39.425821 44.019741 42.318359 43.988281 C 46.676085 43.940902 46.918726 43.921722 47.490234 43.599609 C 48.328016 43.127359 49.291277 42.048617 49.667969 41.160156 C 50.042501 40.276775 50.10924 38.58655 49.816406 37.65625 C 49.262561 36.031217 46.709829 34.278959 45.09375 35.378906 C 44.811276 35.699621 44.540274 35.419187 44.490234 35.367188 C 44.440255 35.315209 44.712092 35.070175 44.849609 34.578125 C 45.033245 33.920559 45.083616 33.265564 45.041016 32.105469 C 44.986797 30.630021 44.94315 30.4397 44.357422 29.185547 C 43.101449 26.496267 40.593192 25.05993 37.945312 25.011719 z"/>
</svg>
EOF
}

