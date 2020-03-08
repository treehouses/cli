#!/bin/bash
if [ ! -f /usr/lib/node_modules/bats-support/load.bash ]; then
  npm install --unsafe-perm -g bats-support@0.3.0
fi

if [ ! -f /usr/lib/node_modules/bats-assert/load.bash ]; then
  npm install --unsafe-perm -g bats-assert@2.0.0
fi

load '../../../node_modules/bats-support/load'
load '../../../node_modules/bats-assert/load'

function check_networkmode {
  if [[ $(pstree -ps $$) == *"ssh"* ]] && [[ $(${clicmd} networkmode) == *wifi* ]]; then
    skip "You are using Wifi and SSH"
  fi 
}

setup() {
  export clinom="cli.sh"
  export clicmd="${BATS_TEST_DIRNAME}/../cli.sh" 
}

teardown() {
  if [ -f /etc/treehouses.conf ]; then rm /etc/treehouses.conf; fi 
}
