#!/usr/bin/env bats
load test-helper

@test "$clinom tor add 22" {
  run "${clicmd}" tor add 22
  assert_success && assert_output -p 'Success'
}

@test "$clinom tor start" {
  run "${clicmd}" tor start
  assert_success && assert_output -p 'Success'
}

@test "$clinom tor list" {
  run "${clicmd}" tor list
  assert_success && assert_output -p 'local'
}

@test "$clinom tor status" {
  run "${clicmd}" tor status
  assert_success && assert_output -p 'active'
}

@test "$clinom tor refresh" {
  run "${clicmd}" tor refresh
  assert_success && assert_output -p 'Success'
}

@test "$clinom tor stop" {
  sleep 5
  run "${clicmd}" tor stop
  assert_success && assert_output -p 'Success'
}

@test "$clinom tor delete 22" {
  run "${clicmd}" tor delete 22
  assert_success && assert_output -p 'has been deleted'
}

@test "$clinom tor start" {
  run "${clicmd}" tor start
  assert_success && assert_output -p 'Success'
}

@test "$clinom tor" {
  run "${clicmd}" tor
  assert_success && assert_output -p '.onion'
}

@test "$clinom tor add 22" {
  run "${clicmd}" tor add 22
  assert_success && assert_output -p 'Success'
}

@test "$clinom tor notice now" {
  run "${clicmd}" tor notice now
  assert_success && assert_output -p 'Thanks'
}
