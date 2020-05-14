#!/usr/bin/env bats
load test-helper

@test "$clinom cron tor" {
  run "${clicmd}" cron tor
  sleep 5
  run "${clicmd}" cron tor
  assert_success && assert_output -p 'removed'
}

@test "$clinom cron timestamp" {
  run "${clicmd}" cron timestamp
  sleep 5
  run "${clicmd}" cron timestamp
  assert_success && assert_output -p 'removed'
}

@test "$clinom cron 0W" {
  run "${clicmd}" cron 0W
  sleep 5
  run "${clicmd}" cron 0W
  assert_success && assert_output -p 'removed'
}

@test "$clinom cron list" {
  run "${clicmd}" cron list
  assert_success && assert_output -p 'no cron'
}
