#!/usr/bin/env bats
load test-helper

@test "$clinom ethernet ${nstaticip} ${ndnsmask} ${ngateway} ${ndns} (check ip...press any key to continue)" {
  if [[ "${ngateway}" == "192.168.2.200" ]]; then
    skip "No ip settings set in test-cli.sh"
  fi
  run "${clicmd}" ethernet ${nstaticip} ${ndnsmask} ${ngateway} ${ndns}
  assert_success
  assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}
