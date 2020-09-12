#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/mongodb

  # create yml(s)
  {
    echo "version: '3.7'"
    echo
    echo "services:"
    echo "  mongodb:"
    echo "    image: treehouses/rpi-mongo"
    echo "    restart: always "
    echo "    init: true"
    echo "    ports:"
    echo "      -  \"27017:27017"\"
    echo "      -  \"27018:27018"\"
    echo "      -  \"27019:27019"\"
    echo "      -  \"28017:28017"\"
    echo "    environment: "
    echo "      - MONGO_INITDB_ROOT_USERNAME=\${MONGO_INITDB_ROOT_USERNAME_VAR}"
    echo "      - MONGO_INITDB_ROOT_PASSWORD=\${MONGO_INITDB_ROOT_PASSWORD_VAR}"
  } > /srv/mongodb/mongodb.yml

  # create .env with default values
  {
    echo "MONGO_INITDB_ROOT_USERNAME_VAR=root"
    echo "MONGO_INITDB_ROOT_PASSWORD_VAR=example"
  } > /srv/mongodb/.env

  # add autorun
  {
    echo "mongodb_autorun=true"
    echo
    echo "if [ \"\$mongodb_autorun\" = true ]; then"
    echo "  docker-compose -f /srv/mongodb/mongodb.yml -p mongodb up -d"
    echo "fi"
    echo
    echo
  } > /srv/mongodb/autorun
}

# environment var
function uses_env {
  echo true
}

# add supported arch(es)
function supported_arches {
  echo "armv7l"
  echo "armv6l"
}

# add port(s)
function get_ports {
  echo "27017"
  echo "27018"
  echo "27019"
  echo "28017"
}

# add size (in MB)
function get_size {
  echo "258"
}

# add info
function get_info {
  echo "\"https://github.com/treehouses/rpi-mongo"
  echo
  echo "You can connect mongodb container by mongo \"mongodb://treehouses.local:27017\""
  echo "Your machine must have mongodb server"
  echo "You can check out if you have mongodb server by mongo --version"
  echo "If not, please install mongodb server"
  echo "https://docs.mongodb.com/manual/installation/"
  echo
  echo "MongoDB is a general purpose, document-based, " 
  echo "distributed database built for modern "
  echo "application developers and for the cloud era. " 
  echo "No database makes you more productive. "\"
}

# add svg icon
function get_icon {
  cat <<EOF
<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1112.61 300">
  <defs>
    <style>.cls-1{fill:#10aa50;}.cls-2{fill:#b8c4c2;}.cls-3{fill:#12924f;}.cls-4{fill:#21313c;}</style>
  </defs>
  <title>MongoDB_Logo_FullColorBlack_RGB</title>
  <path class="cls-1" d="M134.44,120.34C119.13,52.8,87.22,34.82,79.08,22.11a144.57,144.57,0,0,1-8.9-17.42c-.43,6-1.22,9.78-6.32,14.33C53.62,28.15,10.13,63.59,6.47,140.33c-3.41,71.55,52.6,115.67,60,120.23,5.69,2.8,12.62.06,16-2.51,27-18.53,63.89-67.93,52-137.71" />
  <path class="cls-2" d="M72.5,222.46c-1.41,17.71-2.42,28-6,38.12,0,0,2.35,16.86,4,34.72h5.84a324.73,324.73,0,0,1,6.37-37.39C75.15,254.19,72.79,238,72.5,222.46Z" />
  <path class="cls-3" d="M82.7,257.92h0c-7.64-3.53-9.85-20.06-10.19-35.46a725.83,725.83,0,0,0,1.65-76.35c-.4-13.36.19-123.74-3.29-139.9A134.29,134.29,0,0,0,79.08,22.1c8.14,12.72,40.06,30.7,55.36,98.24C146.36,190,109.67,239.27,82.7,257.92Z" />
  <path class="cls-4" d="M1089.7,233.5a16.59,16.59,0,1,1,16.59-16.82,16.38,16.38,0,0,1-16.59,16.82m0-31.68a15.1,15.1,0,1,0,15,15.14,14.85,14.85,0,0,0-15-15.14m4,25.58-4.28-9.23h-3.45v9.23h-2.51v-21h6.19c4.61,0,6.53,2,6.53,5.87,0,3.08-1.45,5-4.15,5.59l4.42,9.51ZM1086.07,216h3.63c2.94,0,4.06-1,4.06-3.68s-1.07-3.59-4.38-3.59h-3.31Z" />
  <path class="cls-4" d="M842.79,218.38c4.49,3.59,13.46,5.07,21.37,5.07,10.25,0,20.3-1.9,30.12-10.77,10-9.09,16.88-23,16.88-45.21,0-21.34-8.12-38.66-24.78-48.8-9.4-5.91-21.58-8.24-35.47-8.24-4,0-8.12.21-10.46,1.27a5.49,5.49,0,0,0-1.93,3c-.42,3.8-.42,32.74-.42,49.85,0,17.54,0,42,.42,45,.22,2.54,1.5,7,4.27,8.87M800.15,100.93c3.63,0,17.43.63,23.85.63,12,0,20.29-.63,42.72-.63,18.8,0,34.62,5.07,45.93,14.78,13.68,11.84,21,28.31,21,48.38,0,28.52-13,45-26.07,54.29-13,9.72-29.91,15.21-54,15.21-12.82,0-34.83-.42-53.2-.63H800c-.86-1.69,1.57-8.28,3.07-8.45,5-.56,6.32-.76,8.62-1.71,3.88-1.59,4.79-3.57,5.22-10.54.64-13.1.43-28.73.43-46.48,0-12.67.21-37.39-.21-45.21-.65-6.54-3.41-8.23-9-9.5a116.24,116.24,0,0,0-12-1.9c-.42-1.27,2.86-7,3.93-8.24" />
  <path class="cls-4" d="M986.6,111.65c-.85.21-1.92,2.33-1.92,3.38-.22,7.61-.43,27.46-.43,41.19a1.36,1.36,0,0,0,1.07,1.06c2.77.21,9.61.43,15.38.43,8.12,0,12.82-1.06,15.38-2.33,6.84-3.38,10-10.78,10-18.8,0-18.38-12.82-25.35-31.83-25.35a57.35,57.35,0,0,0-7.69.42m48.5,84.5c0-18.59-13.68-29.15-38.68-29.15-1.06,0-9-.21-10.89.21-.64.21-1.28.63-1.28,1.06,0,13.31-.22,34.64.43,43.09.43,3.59,3,8.66,6.19,10.14,3.42,1.9,11.11,2.32,16.45,2.32,14.74,0,27.78-8.23,27.78-27.67M948,101.3c1.93,0,7.61.63,22.14.63,13.67,0,24.78-.42,38-.42,16.45,0,39.09,5.92,39.09,30.42,0,12-8.54,21.76-19.65,26.41-.64.21-.64.63,0,.84,15.81,4,29.69,13.73,29.69,32.32,0,18.17-11.32,29.58-27.77,36.76-10,4.44-22.43,5.91-35,5.91-9.61,0-35.37-1-49.69-.84-1.5-.63,1.37-7.4,2.65-8.45a39.38,39.38,0,0,0,9.69-1.52c5.12-1.26,5.73-2.91,6.37-10.52.43-6.55.43-30,.43-46.69,0-22.82.22-38.23,0-45.84-.21-5.91-2.35-7.82-6.41-8.87-3.2-.64-8.54-1.27-12.81-1.9-1.07-1.06,2.22-7.4,3.28-8.24" />
  <path class="cls-4" d="M181.75,233.5a9.26,9.26,0,0,1-.65-4.27,5.43,5.43,0,0,1,.65-2.85,72.58,72.58,0,0,0,8.2-1.67c3.78-.94,5.2-3,5.42-7.82.62-11.39.66-32.76.44-47.78v-.44c0-1.62,0-3.82-2-5.37a42.94,42.94,0,0,0-11.33-5c-1.79-.53-2.78-1.47-2.73-2.57s1.18-2.4,3.51-2.86c6.19-.63,22.41-4.5,28.78-7.44a4.22,4.22,0,0,1,.85,3c0,.66-.1,1.36-.17,2.08-.18,2.12-.38,4.53-.38,6.93a1.58,1.58,0,0,0,2.68.91c12.13-9.51,23-12.9,28.57-12.9,9.17,0,16.31,4.38,21.84,13.4a1.47,1.47,0,0,0,1.24.73,1.42,1.42,0,0,0,1.16-.62c11.15-8.46,22.2-13.51,29.6-13.51,17.48,0,27.93,13.09,27.93,35,0,6.3-.06,14.29-.12,21.74-.05,6.54-.1,12.67-.1,16.91,0,1,1.38,3.88,3.45,4.45,2.56,1.25,6.25,1.89,10.92,2.69l.18,0c.35,1.26-.39,6.15-1.1,7.15-1.16,0-2.76-.1-4.76-.2-3.63-.18-8.61-.43-14.4-.43-11.62,0-17.69.22-23.49.6-.44-1.45-.59-6.13-.06-7.11A61.55,61.55,0,0,0,303,224.7c3.7-1.22,4.77-2.9,5-7.81.09-3.49.76-34.24-.43-41.54-1.1-7.57-6.8-16.43-19.27-16.43-4.63,0-12.1,1.93-19.22,7.33a2.8,2.8,0,0,0-.7,1.81v.15c.84,3.94.84,8.54.84,15.49,0,4,0,8.17-.05,12.34-.05,8.48-.09,16.48.05,22.53,0,4.12,2.49,5.11,4.5,5.9,1.09.24,1.95.45,2.82.65,1.67.41,3.41.83,6,1.24a11.49,11.49,0,0,1-.1,5.32,4.26,4.26,0,0,1-.75,1.81c-6.46-.22-13.09-.41-22.66-.41-2.9,0-7.63.12-11.81.23-3.39.09-6.59.18-8.41.19a8.24,8.24,0,0,1-.64-3.68,6.38,6.38,0,0,1,.67-3.44l2.57-.47c2.24-.4,4.18-.74,6-1.2,3.16-1,4.35-2.72,4.58-6.75.62-9.4,1.1-36.49-.23-43.27-2.26-10.88-8.45-16.4-18.41-16.4-5.83,0-13.2,2.81-19.22,7.32a5.86,5.86,0,0,0-1.77,4.35c0,3.23,0,7.07,0,11.19,0,13.6-.09,30.53.24,37.85.2,2.26,1,4.94,5.23,5.92.93.27,2.53.53,4.39.84,1.07.18,2.24.37,3.45.59a15.16,15.16,0,0,1-.57,7.15c-1.86,0-4.15-.12-6.77-.23-4-.18-9-.4-14.65-.4-6.68,0-11.33.22-15.06.4-2.51.12-4.68.22-6.85.23" />
  <path class="cls-4" d="M396.2,154.49A18.22,18.22,0,0,0,386,157.36c-7.42,4.51-11.2,13.52-11.2,26.76,0,24.78,12.41,42.09,30.18,42.09A19,19,0,0,0,418,221.6c5.46-4.45,8.36-13.55,8.36-26.29,0-24.41-12.13-40.82-30.18-40.82m3.42,80.91c-32.1,0-43.53-23.55-43.53-45.58,0-15.39,6.29-27.42,18.7-35.77a57.11,57.11,0,0,1,28.89-8.54c24.49,0,41.6,17.61,41.6,42.84,0,17.14-6.83,30.68-19.76,39.14-6.21,3.8-17,7.91-25.9,7.91" />
  <path class="cls-4" d="M723,154.49a18.17,18.17,0,0,0-10.22,2.87c-7.42,4.51-11.2,13.52-11.2,26.76,0,24.78,12.41,42.09,30.18,42.09a19,19,0,0,0,13.06-4.61c5.46-4.45,8.35-13.55,8.35-26.29,0-24.41-12.12-40.82-30.17-40.82m3.42,80.91c-32.1,0-43.53-23.55-43.53-45.57,0-15.41,6.29-27.43,18.71-35.78a57,57,0,0,1,28.88-8.54c24.49,0,41.6,17.62,41.6,42.83,0,17.16-6.83,30.69-19.76,39.14-6.21,3.81-17,7.92-25.9,7.92" />
  <path class="cls-4" d="M614.92,153.65c-9.89,0-16.29,7.81-16.29,19.9s5.51,26.46,21,26.46c2.66,0,7.48-1.18,9.87-3.81,3.6-3.31,6-10.15,6-17.37,0-15.77-7.68-25.18-20.53-25.18m-1.28,83.44a16.29,16.29,0,0,0-8,2c-7.83,5-11.46,10-11.46,15.81,0,5.44,2.11,9.77,6.65,13.61,5.5,4.66,12.92,6.93,22.67,6.93,19.19,0,27.79-10.32,27.79-20.54,0-7.12-3.57-11.89-10.92-14.59-5.66-2.07-15.12-3.21-26.7-3.21m1.28,49c-11.52,0-19.82-2.43-26.91-7.89-6.9-5.32-10-13.22-10-18.68a14.61,14.61,0,0,1,3.78-9.5c2-2.28,6.65-6.55,17.4-13.94a.92.92,0,0,0,.56-.85.89.89,0,0,0-.68-.88c-8.85-3.39-11.52-9-12.33-12,0-.11,0-.28-.09-.47-.25-1.18-.49-2.3,1.12-3.45,1.24-.88,3.22-2.06,5.34-3.31a71.89,71.89,0,0,0,8.59-5.59,1.41,1.41,0,0,0-.36-2.2c-13.1-4.4-19.7-14.13-19.7-29a28.83,28.83,0,0,1,12.1-23.73c5.27-4.17,18.5-9.18,27.07-9.18h.5c8.81.21,13.78,2.06,20.66,4.6a32.84,32.84,0,0,0,12.22,1.94c7.29,0,10.48-2.31,13.22-5a11.47,11.47,0,0,1,.7,3.78,14.22,14.22,0,0,1-2.38,8.68c-1.49,2.07-5,3.57-8.21,3.57-.33,0-.65,0-1-.05a26.94,26.94,0,0,1-5-.83l-.82.29c-.26.38-.09.8.12,1.34a1.7,1.7,0,0,1,.12.33,58.52,58.52,0,0,1,1.19,8.1c0,15.55-6.13,22.32-12.76,27.34a43.56,43.56,0,0,1-22,8.52h0c-.17,0-1,.07-2.56.21-1,.09-2.3.21-2.49.21l-.19,0c-1.44.4-5.2,2.19-5.2,5.52,0,2.76,1.7,6.19,9.83,6.81l5.26.37c10.72.75,24.11,1.68,30.41,3.81a21.06,21.06,0,0,1,14.07,20.27c0,13.95-9.92,27.07-26.53,35.09a57.66,57.66,0,0,1-25.09,5.63" />
  <path class="cls-4" d="M565.86,226.06c-4.7-.63-8.13-1.27-12.18-3.17a5.6,5.6,0,0,1-1.5-3c-.43-6.55-.43-25.56-.43-38,0-10.15-1.7-19-6-25.35-5.13-7.19-12.39-11.41-21.79-11.41-8.33,0-19.44,5.7-28.62,13.52-.22.21-1.63,1.55-1.6-.53s.35-6.3.55-9a4.63,4.63,0,0,0-1.4-3.92c-6,3-22.83,7-29.06,7.61-4.54.88-5.69,5.25-.84,6.76l.07,0a41.46,41.46,0,0,1,11,4.84c1.92,1.48,1.71,3.59,1.71,5.28.21,14.15.21,35.91-.43,47.74-.21,4.65-1.5,6.34-4.92,7.19l.32-.11a66.46,66.46,0,0,1-7.91,1.48c-1.07,1.05-1.07,7.18,0,8.45,2.14,0,13-.63,22-.63,12.38,0,18.79.63,22,.63,1.29-1.48,1.71-7.18.86-8.45a45,45,0,0,1-8.77-1.27c-3.41-.84-4.27-2.54-4.48-6.33-.42-9.94-.42-31.06-.42-45.43,0-4,1.06-5.91,2.34-7,4.27-3.8,11.33-6.33,17.52-6.33,6,0,10,1.9,13,4.43A18.1,18.1,0,0,1,533,176c.85,8,.63,24.09.63,38,0,7.61-.63,9.52-3.41,10.36-1.28.63-4.7,1.27-8.76,1.69-1.28,1.27-.86,7.18,0,8.45,5.55,0,12-.63,21.36-.63,11.75,0,19.23.63,22.22.63,1.28-1.48,1.71-7,.86-8.45" />
</svg>
EOF
}
