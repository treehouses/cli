#!/usr/bin/env bats
load test-helper

@test "$clinom timezone Etc/GMT-3" {
  run "${clicmd}" timezone Etc/GMT-3
  assert_success && assert_output -p 'timezone has been set'
}