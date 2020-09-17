#!/usr/bin/env bats
load ../test-helper

@test "$clinom services sysmon info" {
  run "${clicmd}" services sysmon info
  assert_success && assert_output -p 'https://github.com/treehouses/sysmon'
}

@test "$clinom services sysmon install" {
  run "${clicmd}" services sysmon install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services sysmon up" {
  run "${clicmd}" services sysmon up
  sleep 5
  assert_success && assert_output -p 'sysmon built and started'
}

@test "$clinom services sysmon restart" {
  run "${clicmd}" services sysmon restart
  sleep 5
  assert_success && assert_output -p 'sysmon built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'sysmon'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'sysmon'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/sysmon'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'sysmon'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/sysmon'
}

@test "$clinom services sysmon port" {
  run "${clicmd}" services sysmon port
  assert_success && assert_output -p '6969'
}

@test "$clinom services sysmon ps" {
  run "${clicmd}" services sysmon ps
  assert_success && assert_output -p 'treehouses/sysmon'
}

@test "$clinom services sysmon url" {
  run "${clicmd}" services sysmon url
  assert_output -p '6969'
}

@test "$clinom services sysmon autorun" {
  run "${clicmd}" services sysmon autorun
  assert_success
}

@test "$clinom services sysmon autorun true" {
  run "${clicmd}" services sysmon autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services sysmon stop" {
  run "${clicmd}" services sysmon stop
  assert_success && assert_output -p 'sysmon stopped'
}

@test "$clinom services sysmon start" {
  run "${clicmd}" services sysmon start
  assert_success && assert_output -p 'sysmon started'
}

@test "$clinom services sysmon down" {
  run "${clicmd}" services sysmon down
  assert_success && assert_output -p 'sysmon stopped and removed'
}

@test "$clinom services sysmon icon" {
  run "${clicmd}" services sysmon icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services sysmon cleanup" {
  run "${clicmd}" services sysmon cleanup
  assert_success && assert_output -p 'cleaned up'
}
