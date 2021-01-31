#!/bin/bash

function install {

  memory=$(treehouses memory | awk 'END {print $4}' | numfmt --from=iec)
  if [ $memory -lt "800000" ]; then
     echo "ERROR: not enough memory"
     echo "openedx needs 8G RAM"
     exit 1
  fi

  mkdir -p /srv/openedx

  isTutorInstalled=$(ls /usr/local/bin | grep "tutor")
  if [ -z $isTutorInstalled ]; then
    echo "install openedx"
    wget -q  https://github.com/treehouses/openedx/releases/download/v10.0.10-treehouses.1/tutor
    chmod +x tutor
    mv tutor /usr/local/bin/
  fi

  STR=$(treehouses tor)
  SUB='Error'
  if [[ "$STR" == *"$SUB"* ]]; then
    treehouses tor add 80
    treehouses tor start
  fi

  # create yml(s)
  # yml is empty because openedx uses internal ymls
  # it is created for treehouses services to recognize 
  # tutor is installed
  touch /srv/openedx/openedx.yml

  # add autorun
  {
    echo "openedx_autorun=true"
    echo
    echo "if [ \"\$openedx_autorun\" = true ]; then"
    echo "  treehouses services openedx up"
    echo "fi"
    echo
    echo
  } > /srv/openedx/autorun

  # add env.sh, openedx uses the function.
  {
    echo '#!/bin/bash'
    echo
    echo 'function get_email_address {'
    echo '  echo "hiro@ole.org"'
    echo '}'
  } > /srv/openedx/env.sh
}

function up {
  su pi -c "tutor local quickstartfortreehouses"
}

function down {
  su pi -c "tutor local stop"
}

function start {
  su pi -c "tutor local start -d"
}

function stop {
  su pi -c "tutor local stop"
}

function restart {
  su pi -c "tutor local stop"
  su pi -c "tutor local start -d"
}

function cleanup {
  su pi -c "tutor local stop"
  docker rmi $(docker images --filter=reference='treehouses/openedx*' --format "{{.Repository}}:{{.Tag}}")
  openedx_root=$(tutor config printroot)
  rm -rf $openedx_root
  rm /usr/local/bin/tutor
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
  echo "8099"
}

# add size (in MB)
function get_size {
  echo "4940"
}

# add info
function get_info {
  echo "https://github.com/edx/edx-platform"
  echo
  echo "\"edX is the online learning destination co-founded by Harvard and MIT."
  echo "The Open edX platform provides the learner-centric,"
  echo "massively scalable learning technology behind it."
  echo "Originally envisioned for MOOCs,"
  echo "Open edX platform has evolved into one of the leading learning solutions catering"
  echo "to Higher Ed, enterprise, and government organizations alike."\"
}

# add svg icon
function get_icon {
  cat <<EOF
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN"
 "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="1747.000000pt" height="341.000000pt" viewBox="0 0 1747.000000 341.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
Created by potrace 1.16, written by Peter Selinger 2001-2019
</metadata>
<g transform="translate(0.000000,341.000000) scale(0.100000,-0.100000)"
fill="#000000" stroke="none">
<path d="M13520 3135 l0 -275 148 0 147 0 27 -32 27 -33 1 308 0 307 -175 0
-175 0 0 -275z"/>
<path d="M10440 2625 c-479 -82 -872 -410 -1029 -858 -96 -274 -101 -576 -15
-850 124 -392 444 -717 832 -847 156 -52 241 -65 427 -65 238 0 383 33 579
131 179 90 304 196 434 369 67 90 172 271 172 298 0 4 -143 7 -318 7 l-318 0
-39 -41 c-125 -128 -327 -209 -518 -209 -207 1 -381 75 -538 230 -74 73 -93
100 -139 193 -30 59 -52 109 -49 111 2 2 455 5 1006 7 l1003 4 7 45 c11 72 7
298 -6 385 -15 93 -67 256 -117 364 -37 80 -148 254 -183 285 -12 11 -21 25
-21 31 0 17 -107 115 -200 185 -149 110 -350 194 -540 225 -113 18 -324 18
-430 0z m437 -578 c156 -54 300 -163 383 -291 22 -33 44 -66 50 -73 11 -14 50
-109 50 -123 0 -6 -265 -10 -720 -10 l-720 0 21 53 c68 171 235 344 405 418
110 47 180 59 324 55 112 -3 147 -8 207 -29z"/>
<path d="M13825 613 l-40 -52 -132 -1 -133 0 0 -280 0 -280 380 0 380 0 0 280
0 280 -204 0 -205 0 -3 52 -3 53 -40 -52z"/>
</g>
</svg>
EOF
}
