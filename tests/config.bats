#!/usr/bin/env bats
load test-helper

@test "$clinom config add var1 varvalue" {
  run "${clicmd}" config add var1 varvalue
  assert_success && assert_output -p 'Successfully'
}

@test "$clinom config update var2 varvalue" {
  run "${clicmd}" config update var2 varvalue
  assert_success && assert_output -p 'Successfully'
}

@test "$clinom config delete var1" {
  run "${clicmd}" config delete var1
  assert_success && assert_output -p 'Successfully'
}

@test "$clinom config" {
  run "${clicmd}" config
  assert_success && assert_output -p 'var2'
}

@test "$clinom config clear" {
  run "${clicmd}" config clear
  assert_success && assert_output -p 'Successfully'
}
