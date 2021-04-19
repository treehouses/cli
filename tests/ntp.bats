#!/usr/bin/env bats
load test-helper

@test "$clinom ntp (no arguments)" {
  run "${clicmd}" ntp
  assert_failure && assert_output -p 'only local or internet'
}

@test "$clinom ntp (invalid argument)" {
  run "${clicmd}" ntp foobar
  assert_failure && assert_output -p 'only local or internet'
}

@test "$clinom ntp internet" {
  run "${clicmd}" ntp internet
  assert_success && assert_output -p 'Success'
}

@test "$clinom ntp local" {
  run "${clicmd}" ntp local
  assert_success && assert_output -p 'Success'
}

@test "$clinom ntp internet (too many arguments)" {
  run "${clicmd}" ntp internet foobar
  assert_failure && assert_output -p 'Too many arguments.'
}
