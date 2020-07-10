#!/usr/bin/env bats
load test-helper

@test "$clinom picture" {
  run "${clicmd}" picture https://treehouses.io/images/OLE_RPi.png
  assert_success
}