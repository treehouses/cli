#!/usr/bin/env bats
load test-helper

@test "$clinom wifi ${nssidname}" {
  if [[ "${nwifipass}" != "" ]]; then
    skip "Wifi pass is present in test.sh"
  fi
  run "${clicmd}" wifi "${nssidname}" 3>-
  assert_success && assert_output -p 'connected'
}

@test "$clinom wifi ${nssidname} ${nwifipass}" {
  if [[ "${nssidname}" == "YOUR-WIFI-NAME" ]]; then
    skip "No wifi settings set in test.sh"
  fi
  run "${clicmd}" wifi "${nssidname}" "${nwifipass}" 3>-
  assert_success && assert_output -p 'connected'
}