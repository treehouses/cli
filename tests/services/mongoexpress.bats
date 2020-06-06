#!/usr/bin/env bats
load ../test-helper

@test "$clinom services mongoexpress info" {
  run "${clicmd}" services mongoexpress info
  assert_success && assert_output -p 'https://github.com/treehouses/rpi-mongo'
}

@test "$clinom services mongoexpress install" {
  run "${clicmd}" services mongoexpress install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services mongoexpress up" {
  run "${clicmd}" services mongoexpress up
  sleep 5
  assert_success && assert_output -p 'mongoexpress built and started'
}

@test "$clinom services mongoexpress restart" {
  run "${clicmd}" services mongoexpress restart
  sleep 5
  assert_success && assert_output -p 'mongoexpress built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'mongoexpress'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'mongoexpress'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'mongoexpress'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services mongoexpress port" {
  run "${clicmd}" services mongoexpress port
  assert_success && assert_output -p '27017'
}

@test "$clinom services mongoexpress ps" {
  run "${clicmd}" services mongoexpress ps
  assert_success && assert_output -p 'treehouses/rpi-mongo'
}

@test "$clinom services mongoexpress url" {
  run "${clicmd}" services mongoexpress url
  assert_output -p '27017'
}

@test "$clinom services mongoexpress autorun" {
  run "${clicmd}" services mongoexpress autorun
  assert_success
}

@test "$clinom services mongoexpress autorun true" {
  run "${clicmd}" services mongoexpress autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services mongoexpress stop" {
  run "${clicmd}" services mongoexpress stop
  assert_success && assert_output -p 'mongoexpress stopped'
}

@test "$clinom services mongoexpress start" {
  run "${clicmd}" services mongoexpress start
  assert_success && assert_output -p 'mongoexpress started'
}

@test "$clinom services mongoexpress down" {
  run "${clicmd}" services mongoexpress down
  assert_success && assert_output -p 'mongoexpress stopped and removed'
}

@test "$clinom services mongoexpress icon" {
  run "${clicmd}" services mongoexpress icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services mongoexpress cleanup" {
  run "${clicmd}" services mongoexpress cleanup
  assert_success && assert_output -p 'cleaned up'
}
