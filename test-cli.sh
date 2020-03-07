#!/bin/bash
# These tests are designed to be used
# with a RPi that is using its ethernet port
# If the networkmode is Wifi, a lot of the tests
# will be skipped So be sure to run treehouses default network
# for static/wireless testing
export nstaticip=192.168.2.200
export nssidname='YOUR-WIFI-NAME'
export nwifipass='YOUR-WIFI-PASS'
export ngateway='192.168.2.200'
export ndns='192.168.2.200'
export ndnsmask='192.168.2.200'

function check_missing_packages {
  local missing_deps
  missing_deps=()
  for command in "$@"; do
    if [ "$(dpkg-query -W -f='${Status}' $command 2>/dev/null | grep -c 'ok installed')" -eq 0 ]; then
      missing_deps+=( "$command" )
    fi
  done

  if (( ${#missing_deps[@]} > 0 )) ; then
      echo "Missing required programs: ${missing_deps[*]}"
      echo "On Debian/Ubuntu try 'sudo apt install ${missing_deps[*]}'"
      exit 1
  fi
}

check_missing_packages "bats"
if [ "$(id -u)" -ne 0 ];
  then
    echo "Error: Must be run with root permissions"
    exit 1
  fi
bats ./tests
