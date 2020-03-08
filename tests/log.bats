#!/usr/bin/env bats
load test-helper

@test "$clinom log" {
  run "${clicmd}" log
  assert_success && assert_output -p 'log is'
}

@test "$clinom log max" {
  run "${clicmd}" log max
  assert_success && assert_output -p 'log X'
}

@test "$clinom log 4" {
  run "${clicmd}" log 4
  assert_success && assert_output -p 'log 4'
}

@test "$clinom log 3" {
  run "${clicmd}" log 3
  assert_success && assert_output -p 'log 3'
}

@test "$clinom log 2" {
  run "${clicmd}" log 2
  assert_success && assert_output -p 'log 2'
}

@test "$clinom log 1" {
  run "${clicmd}" log 1
  assert_success && assert_output -p 'log 1'
}

@test "$clinom log 0" {
  run "${clicmd}" log 0
  assert_success && assert_output -p 'log 0'
}

@test "$clinom log show" {
  run "${clicmd}" log show
  assert_success && assert_output -p '@treehouses/cli'
}

@test "$clinom log show 5" {
  run "${clicmd}" log show 5
  assert_success && assert_output -p '@treehouses/cli'
}