#!/usr/bin/env bats
load test-helper

@test "$clinom restore (/dev/sdb will take a while)" {
  run "${clicmd}" restore
  if [[ "$output" == *"detected"* ]]; then
    skip "No disk/usb device mounted"
  fi
  assert_success && assert_output -p 'restoring'
}