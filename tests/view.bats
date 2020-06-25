#!/usr/bin/env bats
load test-helper

@test "$clinom view" {
  run "${clicmd}" view https://treehouses.io/images/OLE_RPi.png
  assert_success
}