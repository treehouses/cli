#!/usr/bin/env bats
load test-helper

@test "$clinom clone (/dev/sdb will take a while)" {
  run "${clicmd}" clone
  if [[ "$output" == *"detected"* ]]; then
    skip "No disk/usb device mounted"
  fi
  assert_success && assert_output -p 'A reboot is needed'
}

@test "$clinom clone detect" {
  run "${clicmd}" detect
  assert_success
}