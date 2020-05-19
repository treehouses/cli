#!/usr/bin/env bats
load ../test-helper

@test "$clinom services mongodb info" {
  run "${clicmd}" services mongodb info
  assert_success && assert_output -p 'https://github.com/treehouses/rpi-mongo'
}

@test "$clinom services mongodb install" {
  run "${clicmd}" services mongodb install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services mongodb up" {
  run "${clicmd}" services mongodb up
  sleep 5
  assert_success && assert_output -p 'mongodb built and started'
}

@test "$clinom services mongodb restart" {
  run "${clicmd}" services mongodb restart
  sleep 5
  assert_success && assert_output -p 'mongodb built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'mongodb'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'mongodb'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'mongodb'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services mongodb port" {
  run "${clicmd}" services mongodb port
  assert_success && assert_output -p '27017'
}

@test "$clinom services mongodb ps" {
  run "${clicmd}" services mongodb ps
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services mongodb url" {
  run "${clicmd}" services mongodb url
  assert_output -p '27017'
}

@test "$clinom services mongodb autorun" {
  run "${clicmd}" services mongodb autorun
  assert_success
}

@test "$clinom services mongodb autorun true" {
  run "${clicmd}" services mongodb autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services mongodb stop" {
  run "${clicmd}" services mongodb stop
  assert_success && assert_output -p 'mongodb stopped'
}

@test "$clinom services mongodb start" {
  run "${clicmd}" services mongodb start
  assert_success && assert_output -p 'mongodb started'
}

@test "$clinom services mongodb down" {
  run "${clicmd}" services mongodb down
  assert_success && assert_output -p 'mongodb stopped and removed'
}

@test "$clinom services mongodb icon" {
  run "${clicmd}" services mongodb icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services mongodb cleanup" {
  run "${clicmd}" services mongodb cleanup
  assert_success && assert_output -p 'cleaned up'
}
