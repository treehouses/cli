#!/usr/bin/env bats
load test-helper

@test "$clinom sshkey add \"test\"" {
  run "${clicmd}" sshkey add "test"
  assert_success && assert_output -p 'Added'
}

@test "$clinom sshkey list" {
  run "${clicmd}" sshkey list
  assert_success && assert_output -p 'test'
}

@test "$clinom sshkey delete \"test\"" {
  run "${clicmd}" sshkey delete "test"
  assert_success && assert_output -p 'deleted'
}

@test "$clinom sshkey deleteall (manually test w/out bats - deletes all sshkeys)" {}

@test "$clinom sshkey github adduser dogi" {
  run "${clicmd}" sshkey github adduser dogi
  assert_success
}

@test "$clinom sshkey github deleteuser dogi" {
  run "${clicmd}" sshkey github deleteuser dogi
  assert_success
}

@test "$clinom sshkey github addteam (manually test w/out bats - needs access token)" {}
