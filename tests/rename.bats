#!/usr/bin/env bats
load test-helper

@test "$clinom rename treehouses" {
  run "${clicmd}" rename treehouses
  assert_success && assert_output -p 'Success'
}