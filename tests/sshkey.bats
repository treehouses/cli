#!/usr/bin/env bats
load test-helper

@test "$clinom sshkey add" {
  run "${clicmd}" sshkey add 
  if [[ "$output" == *"invalid"* ]]; then
    skip "Please provide a valid sshkey"
  fi
  assert_success && assert_output -p 'Added sshkey'
}

@test "$clinom sshkey list" {
  run "${clicmd}" sshkey list
  assert_success 
}

@test "$clinom sshkey delete" {
  run "${clicmd}" sshkey delete
  if [[ "$output" == *"Error"* ]]; then
    skip "Please provide a valid sshkey"
  fi
  assert_success && assert_output -p 'Deleted sshkey'
}

@test "$clinom sshkey deleteall" {
  skip "Run $clinom sshkey deleteall manually for testing"
  run "${clicmd}" sshkey deleteall
  [ "$status" -eq 0 ]
}

@test "$clinom sshkey github adduser" {
  run "${clicmd}" sshkey github adduser dogi
  if [[ "$output" == *"Error"* ]]; then
    skip "Please provide a valid Github username"
  fi
  assert_success
}

@test "$clinom sshkey github deleteuser" {
  run "${clicmd}" sshkey github deleteuser dogi
  if [[ "$output" == *"Error"* ]]; then
    skip "Please provide a valid Github username"
  fi
  assert_success
}

@test "$clinom sshkey github addteam" {
  run "${clicmd}" sshkey github addteam
  if [[ "$output" == *"Error"* ]]; then
    skip "Please provide arguments: <organization> <team_name> <access_token>"
  fi
  assert_success
}
