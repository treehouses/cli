#!/usr/bin/env bats
load ../test-helper

@test "$clinom services musicblocks info" {
  run "${clicmd}" services musicblocks info
  assert_success && assert_output -p 'https://github.com/treehouses/musicblocks'
}

@test "$clinom services musicblocks install" {
  run "${clicmd}" services musicblocks install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services musicblocks up" {
  run "${clicmd}" services musicblocks up
  sleep 5
  assert_success && assert_output -p 'musicblocks built and started'
}

@test "$clinom services musicblocks restart" {
  run "${clicmd}" services musicblocks restart
  sleep 5
  assert_success && assert_output -p 'musicblocks built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'musicblocks'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'musicblocks'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/musicblocks'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'musicblocks'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/musicblocks'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services musicblocks port" {
  run "${clicmd}" services musicblocks port
  assert_success && assert_output -p '8088'
}

@test "$clinom services musicblocks ps" {
  run "${clicmd}" services musicblocks ps
  assert_success && assert_output -p 'treehouses/musicblocks'
}

@test "$clinom services musicblocks url" {
  run "${clicmd}" services musicblocks url
  assert_output -p '8088'
}

@test "$clinom services musicblocks autorun" {
  run "${clicmd}" services musicblocks autorun
  assert_success
}

@test "$clinom services musicblocks autorun true" {
  run "${clicmd}" services musicblocks autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services musicblocks stop" {
  run "${clicmd}" services musicblocks stop
  assert_success && assert_output -p 'musicblocks stopped'
}

@test "$clinom services musicblocks start" {
  run "${clicmd}" services musicblocks start
  assert_success && assert_output -p 'musicblocks started'
}

@test "$clinom services musicblocks down" {
  run "${clicmd}" services musicblocks down
  assert_success && assert_output -p 'musicblocks stopped and removed'
}

@test "$clinom services musicblocks icon" {
  run "${clicmd}" services musicblocks icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services musicblocks cleanup" {
  run "${clicmd}" services musicblocks cleanup
  assert_success && assert_output -p 'cleaned up'
}
