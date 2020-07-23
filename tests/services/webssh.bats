#!/usr/bin/env bats
load ../test-helper

@test "$clinom services webssh info" {
  run "${clicmd}" services webssh info
  assert_success && assert_output -p 'https://github.com/treehouses/webssh'
}

@test "$clinom services webssh install" {
  run "${clicmd}" services webssh install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services webssh up" {
  run "${clicmd}" services webssh up
  sleep 5
  assert_success && assert_output -p 'webssh built and started'
}

@test "$clinom services webssh restart" {
  run "${clicmd}" services webssh restart
  sleep 5
  assert_success && assert_output -p 'webssh built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'webssh'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'webssh'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/webssh'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'webssh'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/webssh'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 8888'
}

@test "$clinom services webssh port" {
  run "${clicmd}" services webssh port
  assert_success && assert_output -p '8888'
}

@test "$clinom services webssh ps" {
  run "${clicmd}" services webssh ps
  assert_success && assert_output -p 'treehouses/webssh'
}

@test "$clinom services webssh url" {
  run "${clicmd}" services webssh url
  assert_output -p '8888'
}

@test "$clinom services webssh autorun" {
  run "${clicmd}" services webssh autorun
  assert_success
}

@test "$clinom services webssh autorun true" {
  run "${clicmd}" services webssh autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services webssh stop" {
  run "${clicmd}" services webssh stop
  assert_success && assert_output -p 'webssh stopped'
}

@test "$clinom services webssh start" {
  run "${clicmd}" services webssh start
  assert_success && assert_output -p 'webssh started'
}

@test "$clinom services webssh down" {
  run "${clicmd}" services webssh down
  assert_success && assert_output -p 'webssh stopped and removed'
}

@test "$clinom services webssh icon" {
  run "${clicmd}" services webssh icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services webssh cleanup" {
  run "${clicmd}" services webssh cleanup
  assert_success && assert_output -p 'cleaned up'
}