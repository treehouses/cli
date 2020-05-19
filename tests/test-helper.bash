#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: Must be run with root permissions"
  exit 1
fi
if [ ! -f /usr/lib/node_modules/bats-assert/load.bash ]; then
  npm install --silent --unsafe-perm -g bats-support@0.3.0 &>/dev/null
  npm install --silent --unsafe-perm -g bats-assert@2.0.0 &>/dev/null
fi

load "/usr/lib/node_modules/bats-support/load.bash"
load "/usr/lib/node_modules/bats-assert/load.bash"

function check_networkmode {
  if [[ $(pstree -ps $$) == *"ssh"* ]] && [[ $(${clicmd} networkmode) == *wifi* ]]; then
    skip "You are using Wifi and SSH"
  fi
}

setup() {
  local DIR=$(realpath $PWD)
  while [ ! -z "$DIR" ] && [ ! -f "$DIR/cli.sh" ]; do
    DIR="${DIR%\/*}"
  done
  export clicmd="$DIR/cli.sh"
  export clinom="cli.sh"
}

teardown() {
  if [ -f /etc/treehouses.conf ]; then rm /etc/treehouses.conf; fi
}
