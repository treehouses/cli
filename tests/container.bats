#!/usr/bin/env bats
load test-helper

@test "$clinom container" {
  run "${clicmd}" container
  assert_success && ( assert_output -p 'balena' || assert_output -p 'none' || assert_output -p 'docker' )
}

@test "$clinom container balena" {
  run "${clicmd}" container balena
  assert_success && assert_output -p 'Success'
}

@test "$clinom container none" {
  run "${clicmd}" container none
  assert_success && assert_output -p 'Success'
}

@test "$clinom container docker" {
  run "${clicmd}" container docker
  assert_success && assert_output -p 'Success'
}

@test "$clinom container foo (invalid container)" {
  run "${clicmd}" container asdf
  assert_output -p 'Error: only'
}
