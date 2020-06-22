#!/usr/bin/env bats
load ../test-helper

@test "$clinom services transmission info" {
  run "${clicmd}" services transmission info
  assert_success && assert_output -p 'https://github.com/linuxserver/docker-transmission'
}

@test "$clinom services transmission install" {
  run "${clicmd}" services transmission install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services transmission up" {
  run "${clicmd}" services transmission up
  sleep 5
  assert_success && assert_output -p 'transmission built and started'
}

@test "$clinom services transmission start" {
  run "${clicmd}" services transmission start
  sleep 5
  assert_success && assert_output -p 'transmission started'
}

@test "$clinom services transmission restart" {
  run "${clicmd}" services transmission restart
  sleep 5
  assert_success && assert_output -p 'transmission built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'transmission'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'transmission'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'linuxserver/transmission'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'transmission'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'linuxserver/transmission'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 9091'
}

@test "$clinom services transmission port" {
  run "${clicmd}" services transmission port
  assert_success && assert_output -p '9091'
}

@test "$clinom services transmission ps" {
  run "${clicmd}" services transmission ps
  assert_success && assert_output -p 'linuxserver/transmission'
}

@test "$clinom services transmission url" {
  run "${clicmd}" services transmission url
  assert_output -p '9091'
}

@test "$clinom services transmission autorun" {
  run "${clicmd}" services transmission autorun
  assert_success
}

@test "$clinom services transmission autorun true" {
  run "${clicmd}" services transmission autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services transmission stop" {
  run "${clicmd}" services transmission stop
  assert_success && assert_output -p 'transmission stopped'
}

@test "$clinom services transmission down" {
  run "${clicmd}" services transmission down
  assert_success && assert_output -p 'transmission stopped and removed'
}

@test "$clinom services transmission icon" {
  run "${clicmd}" services transmission icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services transmission cleanup" {
  run "${clicmd}" services transmission cleanup
  assert_success && assert_output -p 'cleaned up'
}
