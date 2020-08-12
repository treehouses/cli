#!/usr/bin/env bats
load ../test-helper

@test "$clinom services novnc info" {
  run "${clicmd}" services novnc info
  assert_success && assert_output -p 'https://github.com/treehouses/novnc'
}

@test "$clinom services novnc install" {
  run "${clicmd}" services novnc install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services novnc up" {
  run "${clicmd}" services novnc up
  sleep 5
  assert_success && assert_output -p 'novnc built and started'
}

@test "$clinom services novnc restart" {
  run "${clicmd}" services novnc restart
  sleep 5
  assert_success && assert_output -p 'novnc built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'novnc'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'novnc'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/novnc'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'novnc'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/novnc'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 6080'
}

@test "$clinom services novnc port" {
  run "${clicmd}" services novnc port
  assert_success && assert_output -p '6080'
}

@test "$clinom services novnc ps" {
  run "${clicmd}" services novnc ps
  assert_success && assert_output -p 'treehouses/novnc'
}

@test "$clinom services novnc url" {
  run "${clicmd}" services novnc url
  assert_output -p '6080'
}

@test "$clinom services novnc autorun" {
  run "${clicmd}" services novnc autorun
  assert_success
}

@test "$clinom services novnc autorun true" {
  run "${clicmd}" services novnc autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services novnc stop" {
  run "${clicmd}" services novnc stop
  assert_success && assert_output -p 'novnc stopped'
}

@test "$clinom services novnc start" {
  run "${clicmd}" services novnc start
  assert_success && assert_output -p 'novnc started'
}

@test "$clinom services novnc down" {
  run "${clicmd}" services novnc down
  assert_success && assert_output -p 'novnc stopped and removed'
}

@test "$clinom services novnc icon" {
  run "${clicmd}" services novnc icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services novnc cleanup" {
  run "${clicmd}" services novnc cleanup
  assert_success && assert_output -p 'cleaned up'
}
