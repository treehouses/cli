#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/piwigo/config

  # create yml(s)
  cat << EOF > /srv/piwigo/piwigo.yml
version: "3.7"
services:
  piwigo:
    image: linuxserver/piwigo
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Eastern
    volumes:
      - /srv/piwigo/config:/config
    ports:
      - 8094:80
    restart: unless-stopped
    depends_on:
      - db
  db:
    image: jsurf/rpi-mariadb
    restart: unless-stopped
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=\${MYSQL_ROOT_PASSWORD_VAR}
      - MYSQL_DATABASE=\${MYSQL_DATABASE_VAR} 
    volumes:
      - /srv/piwigo/datadir:/var/lib/mysql
EOF

  # create .env with default values
  cat << EOF  > /srv/piwigo/.env
MYSQL_ROOT_PASSWORD_VAR=my-secret-pw
MYSQL_DATABASE_VAR=piwigo
EOF


  # add autorun
  cat << EOF > /srv/piwigo/autorun
piwigo_autorun=true

if [ "$piwigo_autorun" = true ]; then
  treehouses services piwigo up
fi


EOF
}

# environment var
function uses_env {
  echo true
}

# add supported arch(es)
function supported_arches {
  echo "armv7l"
  echo "aarch64"
  echo "x86_64"
}

# add port(s)
function get_ports {
  echo "8094"
}

# add size (in MB)
function get_size {
  echo "504"
}

# add description
function get_description {
  echo "Piwigo is a photo gallery software to publish and manage your collection of pictures"
}

# add info
function get_info {
  echo "https://github.com/linuxserver/docker-piwigo"
  echo
  echo "Piwigo is a photo gallery software for the web that comes with powerful features to publish and manage your collection of pictures."
  echo "please use database name \"piwigo\" and \"root\" password \"my-secret-pw\""
}

# add svg icon
function get_icon {
  cat <<EOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 767.6 191">
  <defs/>
  <defs>
    <style>
      .cls-1{fill:#3c3c3c}.cls-2{fill:#f70}.cls-3{fill:#fff}
    </style>
  </defs>
  <g id="Symbole_23_1" data-name="Symbole 23 – 1" transform="translate(-577 -446.516)">
    <path id="Tracé_3456" d="M48.953-42.57c1.466-.943 4.51-.83 4.51-.83H64.8a75.758 75.758 0 0028.1-5.1A46.707 46.707 0 00113.6-64q7.8-10.4 7.8-25.6 0-15.4-7.3-25.8a43.832 43.832 0 00-19.7-15.5 72.474 72.474 0 00-27.8-5.1H26.286s-4.763-.041-7.4 1.925-2.483 5.564-2.483 5.564V-3.588a3.986 3.986 0 00.77 2.735 4.788 4.788 0 002.9.853h23.884a4.221 4.221 0 002.869-.853c.911-.972.774-3.035.774-3.035v-35.739a3.519 3.519 0 011.353-2.943zM65.6-110.8q11 0 17.1 5.6t6.1 16.4q-.2 9.4-6.5 14.9T66-68.4H50.653a3.693 3.693 0 01-2.331-.742 3.813 3.813 0 01-.722-2.364v-37.132a2.062 2.062 0 01.722-1.716 5.2 5.2 0 012.5-.446z" class="cls-1" data-name="Tracé 3456" transform="translate(735 592.516)"/>
    <path id="Tracé_3455" d="M152-110.4a16.763 16.763 0 0012.3-5.1 16.533 16.533 0 005.1-12.1 16.763 16.763 0 00-5.1-12.3A16.763 16.763 0 00152-145a16.533 16.533 0 00-12.1 5.1 16.763 16.763 0 00-5.1 12.3 16.533 16.533 0 005.1 12.1 16.533 16.533 0 0012.1 5.1zM166.744-1.253A5.163 5.163 0 00167.8-4.6V-89s.2-3.8-1.622-5.8-5.653-2.2-5.653-2.2H146.1s-4.891.167-7.317 2.8-2.387 7.732-2.387 7.732v79.877s-.182 3.621 1.4 5.269S142.746 0 142.746 0h20.475a6.231 6.231 0 003.523-1.253zm130.162-.5c2.2-1.778 3.011-5.364 3.011-5.364l27.963-85.832s.738-1.925 0-2.938S324.926-97 324.926-97h-22.813a8.712 8.712 0 00-3.818 1.113 5.151 5.151 0 00-1.792 2.841L285.676-45.3a1.478 1.478 0 01-1.531 1.429 1.478 1.478 0 01-1.531-1.429L270.8-92.243a6.42 6.42 0 00-1.879-3.643 7.68 7.68 0 00-4.2-1.113h-21.743a8.845 8.845 0 00-4.06 1.113 5.149 5.149 0 00-1.784 3.05l-9.2 44.235s-.213 1.2-2.768 2.041-3.5-2.041-3.5-2.041l-9.779-43.51s-.312-4.106-2.534-5.735-6.353-.78-6.353-.78l-14.13 4.107s-4.51 1.1-6.014 3.812 0 7.019 0 7.019L207.17-7.6s.641 3.954 3.141 5.855S217.169 0 217.169 0h13.64s3.62-.012 5.709-1.749 2.647-5.2 2.647-5.2L250.631-47.5a2.736 2.736 0 012.768-2.381 2.847 2.847 0 012.844 2.381l11.538 39.84s.468 4 3.092 5.911S278.279 0 278.279 0H291.1s3.6.029 5.806-1.749zM357.2-110.4a16.762 16.762 0 0012.3-5.1 16.533 16.533 0 005.1-12.1 16.763 16.763 0 00-5.1-12.3 16.763 16.763 0 00-12.3-5.1 16.533 16.533 0 00-12.1 5.1 16.763 16.763 0 00-5.1 12.3 16.533 16.533 0 005.1 12.1 16.533 16.533 0 0012.1 5.1zM371.326-1.749C373.259-3.477 373-6.91 373-6.91v-83.526s-.11-3.058-1.541-4.7A7.042 7.042 0 00367.277-97h-18.662s-3.556.212-5.31 1.978-1.7 5.084-1.7 5.084V-8.3s-.307 4.473 1.314 6.546S348.085 0 348.085 0h17.184s4.124-.021 6.057-1.749zM485.84-95.233c.863 1.373.863 6.905.863 6.905L486.4 3.8a38.992 38.992 0 01-6.5 22.4 41.1 41.1 0 01-18.4 14.7Q449.6 46 434 46q-8 0-21.2-3a74.246 74.246 0 01-16.5-5.607 5.014 5.014 0 01-2.827-3.655 7.006 7.006 0 01.628-4.314l4.138-9.684a6.978 6.978 0 013.656-3.64c2.566-.928 4.017-1.092 6.61-.073A64.9 64.9 0 00432.2 20.8q10.2 0 16.5-4.7A14.831 14.831 0 00455 3.6s.809-5.015-3.641-5.365-6.55 3.88-14.159 3.965q-22.6 0-36-13.2t-13.4-37.4q0-24.2 13.6-37.9t37-13.7a38.162 38.162 0 0113.8 2.7c4.667 1.8 8.45 7.575 13 7.7s-.373-7.168 5.2-7.2c3.383-.019 7.234-.007 11.084 0 1.985 0 3.493.194 4.356 1.567zM440.6-22.8c4.4 0 8-.854 11.6-5.134s2.8-11.983 2.8-11.983v-16.46s1-8.867-2.8-13.473-7.067-4.95-12.4-4.95a16.918 16.918 0 00-14.2 7.2q-5.4 7.2-5.4 19 0 12 5.4 18.9t15 6.9zm169-25.6q0 15.6-6.9 27a45.743 45.743 0 01-19.1 17.5q-12.2 6.1-27.8 6.1-15.8 0-27.8-5.9a43.275 43.275 0 01-18.7-17.4q-6.7-11.5-6.7-27.7 0-15.6 6.9-27.2a46.151 46.151 0 0119-17.8q12.1-6.2 27.7-6.2 15.8 0 27.9 6.1a44.223 44.223 0 0118.8 17.7q6.7 11.6 6.7 27.8zM556-23.6q9.6 0 15.4-6.8t5.8-18q0-11.2-5.7-18.4a18.3 18.3 0 00-15.1-7.2q-9.8 0-15.6 6.9T535-48.8q0 11.4 5.7 18.3t15.3 6.9z" class="cls-1" data-name="Tracé 3455" transform="translate(735 591.516)"/>
    <path id="Tracé_3467" d="M36.12 0h64.088a36.12 36.12 0 0136.12 36.12v84.911l-4.842 10.369-10.5 4.93H36.12A36.12 36.12 0 010 100.208V36.12A36.12 36.12 0 0136.12 0z" class="cls-2" data-name="Tracé 3467" transform="rotate(-90 584.6425 7.6425)"/>
    <path id="Tracé_3469" d="M24.641 0C38.167 0 49.59 10.892 49.59 24.418S38.167 48.983 24.641 48.983-36.4 9.469-35.316 9.463s-27.4-.076 9.176 0S8.9.355 24.641 0z" class="cls-2" data-name="Tracé 3469" transform="translate(663.719 446.516)"/>
    <circle id="Ellipse_69" cx="8.557" cy="8.557" r="8.557" class="cls-3" data-name="Ellipse 69" transform="translate(680.344 461.978)"/>
    <circle id="Ellipse_67" cx="40.426" cy="40.426" r="40.426" class="cls-3" data-name="Ellipse 67" transform="translate(604.738 483.695)"/>
    <circle id="Ellipse_68" cx="28.623" cy="28.623" r="28.623" class="cls-1" data-name="Ellipse 68" transform="translate(616.541 495.499)"/>
  </g>
</svg>
EOF
}
