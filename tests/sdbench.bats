#!/usr/bin/env bats
load test-helper

@test "$clinom sdbench" {
  run "${clicmd}" sdbench
  assert_success && assert_output --partial 'read  -' && assert_output --partial 'write -'
}
