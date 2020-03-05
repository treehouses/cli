#!/usr/bin/env bats
load test-helper

@test "/cli.sh blocker" {
  run "${CLICMD}" blocker
  assert_success
  assert_output -p 'blocker is'
}

@test "/cli.sh blocker max" {
  run "${CLICMD}" blocker max
  assert_success
  assert_output -p 'blocker X'
}

@test "/cli.sh blocker 4" {
  run "${CLICMD}" blocker 4
  assert_success
  assert_output -p 'blocker 4'
}

@test "/cli.sh blocker 3" {
  run "${CLICMD}" blocker 3
  assert_success
  assert_output -p 'blocker 3'
}

@test "/cli.sh blocker 2" {
  run "${CLICMD}" blocker 2
  assert_success
  assert_output -p 'blocker 2'
}

@test "/cli.sh blocker 1" {
  run "${CLICMD}" blocker 1
  assert_success
  assert_output -p 'blocker 1'
}

@test "/cli.sh blocker 0" {
  run "${CLICMD}" blocker 0
  assert_success
  assert_output -p 'blocker 0'
}