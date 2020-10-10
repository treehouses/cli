#!/usr/bin/env bats
load ../test-helper

@test "$clinom services ntopng info" {
  run "${clicmd}" services ntopng info
  assert_success && assert_output -p 'https://github.com/ntop/ntopng'
}

@test "$clinom services ntopng install" {
  run "${clicmd}" services ntopng install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services ntopng up" {
  run "${clicmd}" services ntopng up
  sleep 5
  assert_success && assert_output -p 'ntopng built and started'
}

@test "$clinom services ntopng restart" {
  run "${clicmd}" services ntopng restart
  sleep 5
  assert_success && assert_output -p 'ntopng built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'ntopng'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'ntopng'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'jonbackhaus/ntopng'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'ntopng'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'jonbackhaus/ntopng'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services ntopng port" {
  run "${clicmd}" services ntopng port
  assert_success && assert_output -p '8084'
}

@test "$clinom services ntopng ps" {
  run "${clicmd}" services ntopng ps
  assert_success && assert_output -p 'jonbackhaus/ntopng'
}

@test "$clinom services ntopng url" {
  run "${clicmd}" services ntopng url
  assert_output -p '8084'
}

@test "$clinom services ntopng autorun" {
  run "${clicmd}" services ntopng autorun
  assert_success
}

@test "$clinom services ntopng autorun true" {
  run "${clicmd}" services ntopng autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services ntopng stop" {
  run "${clicmd}" services ntopng stop
  assert_success && assert_output -p 'ntopng stopped'
}

@test "$clinom services ntopng start" {
  run "${clicmd}" services ntopng start
  assert_success && assert_output -p 'ntopng started'
}

@test "$clinom services ntopng down" {
  run "${clicmd}" services ntopng down
  assert_success && assert_output -p 'ntopng stopped and removed'
}

@test "$clinom services ntopng icon" {
  run "${clicmd}" services ntopng icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services ntopng cleanup" {
  run "${clicmd}" services ntopng cleanup
  assert_success && assert_output -p 'cleaned up'
}
