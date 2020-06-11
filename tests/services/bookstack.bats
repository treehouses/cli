#!/usr/bin/env bats
load ../test-helper

@test "$clinom services bookstack info" {
  run "${clicmd}" services bookstack info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-bookstack'
}

@test "$clinom services bookstack install" {
  run "${clicmd}" services bookstack install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services bookstack up" {
  run "${clicmd}" services bookstack up
  sleep 5
  assert_success && assert_output -p 'bookstack built and started'
}

@test "$clinom services bookstack start" {
  run "${clicmd}" services bookstack start
  sleep 5
  assert_success && assert_output -p 'bookstack started'
}

@test "$clinom services bookstack restart" {
  run "${clicmd}" services bookstack restart
  sleep 5
  assert_success && assert_output -p 'bookstack built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'bookstack'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'bookstack'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/bookstack'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'bookstack'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/bookstack'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services bookstack port" {
  run "${clicmd}" services bookstack port
  assert_success && assert_output -p '8092'
}

@test "$clinom services bookstack ps" {
  run "${clicmd}" services bookstack ps
  assert_success && assert_output -p 'linuxserver/bookstack'
}

@test "$clinom services bookstack url" {
  run "${clicmd}" services bookstack url
  assert_output -p '8092'
}

@test "$clinom services bookstack autorun" {
  run "${clicmd}" services bookstack autorun
  assert_success
}

@test "$clinom services bookstack autorun true" {
  run "${clicmd}" services bookstack autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services bookstack stop" {
  run "${clicmd}" services bookstack stop
  assert_success && assert_output -p 'bookstack stopped'
}

@test "$clinom services bookstack down" {
  run "${clicmd}" services bookstack down
  assert_success && assert_output -p 'bookstack stopped and removed'
}

@test "$clinom services bookstack icon" {
  run "${clicmd}" services bookstack icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services bookstack cleanup" {
  run "${clicmd}" services bookstack cleanup
  assert_success && assert_output -p 'cleaned up'
}
