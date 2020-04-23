#!/usr/bin/env bats
load test-helper

@test "$clinom wifihidden ${nssidname}" {
  if [[ "${nwifipass}" != "" ]]; then
    skip "Wifi pass is present in test.sh"
  fi
  run "${clicmd}" wifihidden "${nssidname}" 3>-
  assert_success && assert_output -p 'connected'
}

@test "$clinom wifihidden ${nssidname} ${nwifipass}" {
  if [[ "${nssidname}" == "YOUR-WIFI-NAME" ]]; then
    skip "No wifi settings set in test.sh"
  fi
  run "${clicmd}" wifihidden "${nssidname}" "${nwifipass}" 3>-
  assert_success && assert_output -p 'connected'
}