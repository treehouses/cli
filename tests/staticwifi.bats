#!/usr/bin/env bats
load test-helper

@test "$clinom staticwifi ${nstaticip} ${ndnsmask} ${ngateway} ${ndns} ${nssidname} (check wifi...press any key to continue)" {
  check_networkmode
  if [[ "${ngateway}" == "192.168.2.200" ]]; then
    skip "No wifi settings set in test-cli.sh"
  fi
  run "${clicmd}" staticwifi ${nstaticip} ${ndnsmask} ${ngateway} ${ndns} ${nssidname}
  assert_success && assert_output -p 'Success'
  read -n 1 -s -r }

@test "$clinom staticwifi ${nstaticip} ${ndnsmask} ${ngateway} ${ndns} ${nssidname} ${nwifipass}" {
  if [[ "${ngateway}" == "192.168.2.200" ]]; then
    skip "No wifi settings set in test-cli.sh"
  fi
  run "${clicmd}" staticwifi ${nstaticip} ${ndnsmask} ${ngateway} ${ndns} ${nssidname} ${nwifipass}
  assert_success && assert_output -p 'Success' }