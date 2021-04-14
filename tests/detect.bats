#!/usr/bin/env bats
load test-helper

@test "$clinom detect" {
  run "${clicmd}" detect
  assert_success
}

@test "$clinom detect (invalid argument)" {
  run "${clicmd}" detect asdf
  assert_output --partial "options supported."
}

@test "$clinom detect bluetooth" {
  run "${clicmd}" detect bluetooth
  assert_success
}

@test "$clinom detect rpi" {
  run "${clicmd}" detect rpi
  assert_success
}

@test "$clinom detect rpi model" {
  run "${clicmd}" detect rpi model
  assert_success
}

@test "$clinom detect rpi full" {
  run "${clicmd}" detect rpi model
  assert_success
}

@test "$clinom detect rpi (invalid second argument)" {
  run "${clicmd}" detect rpi foobar
  assert_failure && assert_output --partial "commands supported"
}

@test "$clinom detect <option> <an extra unnecessary option> (too many arguments)" {
  run "${clicmd}" detect wifi foobar
  assert_failure && assert_output --partial "Too many arguments"
}

@test "$clinom detect wifi" {
  run "${clicmd}" detect wifi
  assert_success
}

@test "$clinom detect arm" {
  run "${clicmd}" detect arm
  assert_success
}

@test "$clinom detect arch" {
  run "${clicmd}" detect arch
  assert_success
}
