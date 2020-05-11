#!/usr/bin/env bats
load ../test-helper

@test "$clinom services nextcloud info" {
  run "${clicmd}" services nextcloud info
  assert_success && assert_output -p 'https://github.com/nextcloud'
}

@test "$clinom services nextcloud install" {
  run "${clicmd}" services nextcloud install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services nextcloud up" {
  run "${clicmd}" services nextcloud up
  sleep 5
  assert_success && assert_output -p 'nextcloud built and started'
}

@test "$clinom services nextcloud restart" {
  run "${clicmd}" services nextcloud restart
  sleep 5
  assert_success && assert_output -p 'nextcloud built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'nextcloud'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'nextcloud'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'nextcloud'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'nextcloud'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'nextcloud'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services nextcloud port" {
  run "${clicmd}" services nextcloud port
  assert_success && assert_output -p '8081'
}

@test "$clinom services nextcloud ps" {
  run "${clicmd}" services nextcloud ps
  assert_success && assert_output -p 'nextcloud'
}

@test "$clinom services nextcloud url" {
  run "${clicmd}" services nextcloud url
  assert_output -p '8081'
}

@test "$clinom services nextcloud autorun" {
  run "${clicmd}" services nextcloud autorun
  assert_success
}

@test "$clinom services nextcloud autorun true" {
  run "${clicmd}" services nextcloud autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services nextcloud stop" {
  run "${clicmd}" services nextcloud stop
  assert_success && assert_output -p 'nextcloud stopped'
}

@test "$clinom services nextcloud start" {
  run "${clicmd}" services nextcloud start
  assert_success && assert_output -p 'nextcloud started'
}

@test "$clinom services nextcloud down" {
  run "${clicmd}" services nextcloud down
  assert_success && assert_output -p 'nextcloud stopped and removed'
}

@test "$clinom services nextcloud icon" {
  run "${clicmd}" services nextcloud icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services nextcloud cleanup" {
  run "${clicmd}" services nextcloud cleanup
  assert_success && assert_output -p 'cleaned up'
}
