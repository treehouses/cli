#!/usr/bin/env bats
load ../test-helper

@test "$clinom services mongo info" {
  run "${clicmd}" services mongo info
  assert_success && assert_output -p 'https://github.com/treehouses/rpi-mongo'
}

@test "$clinom services mongo install" {
  run "${clicmd}" services mongo install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services mongo up" {
  run "${clicmd}" services mongo up
  sleep 5
  assert_success && assert_output -p 'mongo built and started'
}

@test "$clinom services mongo restart" {
  run "${clicmd}" services mongo restart
  sleep 5
  assert_success && assert_output -p 'mongo built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'mongo'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'mongo'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'mongo'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services mongo port" {
  run "${clicmd}" services mongo port
  assert_success && assert_output -p '8090'
}

@test "$clinom services mongo ps" {
  run "${clicmd}" services mongo ps
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services mongo url" {
  run "${clicmd}" services mongo url
  assert_output -p '8090'
}

@test "$clinom services mongo autorun" {
  run "${clicmd}" services mongo autorun
  assert_success
}

@test "$clinom services mongo autorun true" {
  run "${clicmd}" services mongo autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services mongo stop" {
  run "${clicmd}" services mongo stop
  assert_success && assert_output -p 'mongo stopped'
}

@test "$clinom services mongo down" {
  run "${clicmd}" services mongo down
  assert_success && assert_output -p 'mongo stopped and removed'
}

@test "$clinom services mongo icon" {
  run "${clicmd}" services mongo icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services mongo cleanup" {
  run "${clicmd}" services mongo cleanup
  assert_success && assert_output -p 'cleaned up'
}
