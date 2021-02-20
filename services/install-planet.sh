#!/bin/bash

function install {
  # create service directory
  mkdir -p /srv/planet

  # create yml(s)
  {
    echo "services:"
    echo "  couchdb:"
    echo "    expose:"
    echo "      - 5984"
    echo "    image: treehouses/couchdb:2.3.1"
    echo "    ports:"
    echo "      - \"2200:5984\""
    echo "  db-init:"
    echo "    image: treehouses/planet:db-init-local"
    echo "    depends_on:"
    echo "      - couchdb"
    echo "    environment:"
    echo "      - COUCHDB_HOST=http://couchdb:5984"
    echo "  planet:"
    echo "    image: treehouses/planet:local"
    echo "    ports:"
    echo "      - \"80:80\""
    echo "    volumes:"
    echo "      - \"/var/run/docker.sock:/var/run/docker.sock\""
    echo "    environment:"
    echo "      - MULTIPLE_IPS=true"
    echo "      - HOST_PROTOCOL=http"
    echo "      - DB_HOST=127.0.0.1"
    echo "      - DB_PORT=2200"
    echo "      - CENTER_ADDRESS=planet.earth.ole.org/db"
    echo "    depends_on:"
    echo "      - couchdb"
    echo "version: \"2\""
  } > /srv/planet/planet.yml

  {
    echo "services:"
    echo "  couchdb:"
    echo "    volumes:"
    echo "      - \"/srv/planet/conf:/opt/couchdb/etc/local.d\""
    echo "      - \"/srv/planet/data:/opt/couchdb/data\""
    echo "      - \"/srv/planet/log:/opt/couchdb/var/log\""
    echo "  planet:"
    echo "    volumes:"
    echo "      - \"/srv/planet/pwd:/usr/share/nginx/html/credentials\""
    echo "      - \"/srv/planet/fs:/usr/share/nginx/html/fs\""
    echo "version: \"2\""
  } > /srv/planet/volumes.yml

  # add autorun
  {
    echo "planet_autorun=true"
    echo
    echo "if [ \"\$planet_autorun\" = true ]; then"
    echo "  treehouses services planet up"
    echo "fi"
    echo
    echo
  } > /srv/planet/autorun
}

# environment var
function uses_env {
  echo false
}

# add supported arch(es)
function supported_arches {
  echo "armv7l"
  echo "armv6l"
}

# add port(s)
function get_ports {
  echo "80"
  echo "2200"
}

# add size (in MB)
function get_size {
  echo "450"
}

# add description
function get_description {
  echo "Planet Learning is a generic learning system built in Angular & CouchDB"
}

# add info
function get_info {
  echo "https://github.com/open-learning-exchange/planet"
  echo
  echo "\"Planet Learning is a generic learning system built in Angular"
  echo "& CouchDB.\""
}

# add svg icon
function get_icon {
  cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="8.26772in" height="11.6929in" version="1.1" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd" viewBox="0 0 8268 11693" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <style type="text/css">
    <![CDATA[
      .fil0 {fill:#0070B0}
      .fil1 {fill:#60AE36}
    ]]>
    </style>
  </defs>
  <g id="Layer_x0020_1">
    <g id="_2195878499632">
    <path class="fil0" d="M5353 4672c0,882 331,1352 830,1790 283,249 1372,906 1622,844 45,-167 -152,-207 -275,-297 -1307,-957 -1871,-2490 -1354,-4057 36,-111 184,-387 94,-443 -98,-60 -232,223 -282,307 -277,476 -635,1169 -635,1856z" />
    <path class="fil0" d="M461 4373c-49,182 140,169 468,441 540,446 939,973 1174,1681 562,1697 -467,2944 -25,2666 42,-27 1343,-1777 598,-3213 -228,-441 -535,-719 -917,-979 -164,-112 -1092,-648 -1298,-596z" />
    <path class="fil0" d="M2667 9511c182,49 169,-140 440,-468 447,-540 974,-939 1681,-1173 1698,-563 2945,466 2667,25 -27,-43 -1777,-1343 -3213,-599 -441,228 -720,536 -979,917 -112,165 -648,1092 -596,1298z" />
    <path class="fil0" d="M2472 3984c-504,0 -881,-60 -1342,-228 -138,-50 -231,-133 -328,-53 -94,153 1340,916 2163,917 883,0 1353,-332 1791,-831 248,-283 906,-1372 843,-1622 -194,-52 -240,282 -571,623 -265,273 -339,358 -666,581 -476,324 -1158,613 -1890,613z" />
    <circle class="fil0" cx="7089" cy="4879" r="760" />
    <circle class="fil0" cx="3179" cy="2904" r="760" />
    <circle class="fil0" cx="1179" cy="6789" r="760" />
    <circle class="fil0" cx="5102" cy="8789" r="760" />
    <polygon class="fil1" points="4981,5332 5105,5717 4122,5932 3265,6303 3140,5918 4068,5721 " />
    <polygon class="fil1" points="4972,6315 4701,6621 4023,5877 3273,5320 3544,5014 4179,5719 " />
    <polygon class="fil1" points="4127,4836 4531,4912 4226,5871 4118,6799 3714,6723 4007,5821 " />
    </g>
  </g>
</svg>
EOF
}
