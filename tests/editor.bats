#!/usr/bin/env bats
load test-helper

@test "$clinom editor default" {
  run "${clicmd}" editor default 
  assert_success && assert_output -p 'default'
}

@test "$clinom editor 1" {
  run "${clicmd}" editor
  assert_success && assert_output -p 'vim'
}

@test "$clinom editor set nano" {
  run "${clicmd}" editor set nano 
  assert_success && assert_output -p 'nano'
}

@test "$clinom editor 2" {
  run "${clicmd}" editor
  assert_success && assert_output -p 'nano'
}

@test "$clinom editor config alternate" {
  run "${clicmd}" editor config alternate
  assert_success && assert_output -p 'alternate'
}

@test "$clinom editor config default" {
  run "${clicmd}" editor config default
  assert_success && assert_output -p 'default'
}

