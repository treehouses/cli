#!/usr/bin/env bats
load test-helper
@test "$clinom reboots now (manually test w/out bats - requires reboots)" {}

@test "$clinom reboots in (manually test w/out bats - requires reboots)" {}

@test "$clinom reboots daily" {
  run "${clicmd}" reboots daily
  run "${clicmd}" reboots daily
  assert_success && assert_output -p 'daily removed'
}

@test "$clinom reboots weekly" {
  run "${clicmd}" reboots weekly
  run "${clicmd}" reboots weekly
  assert_success && assert_output -p 'weekly removed'
}

@test "$clinom reboots monthly" {
  run "${clicmd}" reboots monthly
  run "${clicmd}" reboots monthly
  assert_success && assert_output -p 'monthly removed'
}

@test "$clinom reboots cron \"0 * * * *\"" {
  run "${clicmd}" reboots cron "0 * * * *"
  sleep 5
  assert_success && assert_output -p 'added'
  run "${clicmd}" cron delete "0 * * * *"
}
