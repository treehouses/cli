#!/usr/bin/env bats
load test-helper

@test "$clinom wifi ${nssidname} (check wifi...press any key to continue)" {
  if [[ "${nwifipass}" != "" ]]; then
    skip "Wifi pass is present in test-cli.sh"
  fi
  run "${clicmd}" wifi ${nssidname}
  assert_success && assert_output -p 'connected'
  read -n 1 -s -r }

@test "$clinom wifi ${nssidname} ${nwifipass} (check wifi...press any key to continue)" {
  if [[ "${nssidname}" == "YOUR-WIFI-NAME" ]]; then
    skip "No wifi settings set in test-cli.sh"
  fi
  run "${clicmd}" wifi ${nssidname} ${nwifipass}
  assert_success && assert_output -p 'connected'
  read -n 1 -s -r
}