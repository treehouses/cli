#!/usr/bin/env bats
load test-helper

@test "$clinom led wazazi" {
  run "${clicmd}" led wazazi
  assert_success && assert_output -p 'default-on'
}