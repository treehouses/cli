#!/usr/bin/env bats
load test-helper

@test "$clinom burn (/dev/sdb will take a while)" {
  run "${clicmd}" burn
  if [[ "$output" == *"detected"* ]]; then
    skip "No disk/usb device mounted"
  fi
  assert_success && assert_output -p 'the image has been written'
}