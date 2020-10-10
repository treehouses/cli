#!/usr/bin/env bats
load test-helper

@test "$clinom temperature" {
  run "${clicmd}" temperature
  assert_success
}

@test "$clinom temperature fahrenheit" {
  run "${clicmd}" temperature fahrenheit
  assert_success && assert_output -p 'F'
}

@test "$clinom temperature celsius" {
  run "${clicmd}" temperature celsius
  assert_success && assert_output -p 'C'
}

@test "$clinom temperature kelvin" {
  run "${clicmd}" temperature kelvin
  assert_success && assert_output -p 'K'
}
