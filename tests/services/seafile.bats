#!/usr/bin/env bats
load ../test-helper

@test "$clinom services seafile info" {
  run "${clicmd}" services seafile info
  assert_success && assert_output -p 'https://github.com/treehouses/rpi-seafile'
}

@test "$clinom services seafile install" {
  run "${clicmd}" services seafile install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services seafile up" {
  run "${clicmd}" services seafile up
  sleep 5
  assert_success && assert_output -p 'seafile built and started'
}

@test "$clinom services seafile restart" {
  run "${clicmd}" services seafile restart
  sleep 5
  assert_success && assert_output -p 'seafile built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'seafile'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'seafile'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/rpi-seafile'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'seafile'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/rpi-seafile'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services seafile port" {
  run "${clicmd}" services seafile port
  assert_success && assert_output -p '8085'
}

@test "$clinom services seafile ps" {
  run "${clicmd}" services seafile ps
  assert_success && assert_output -p 'treehouses/rpi-seafile'
}

@test "$clinom services seafile url" {
  run "${clicmd}" services seafile url
  assert_output -p '8085'
}

@test "$clinom services seafile autorun" {
  run "${clicmd}" services seafile autorun
  assert_success
}

@test "$clinom services seafile autorun true" {
  run "${clicmd}" services seafile autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services seafile stop" {
  run "${clicmd}" services seafile stop
  assert_success && assert_output -p 'seafile stopped'
}

@test "$clinom services seafile start" {
  run "${clicmd}" services seafile start
  assert_success && assert_output -p 'seafile started'
}

@test "$clinom services seafile down" {
  run "${clicmd}" services seafile down
  assert_success && assert_output -p 'seafile stopped and removed'
}

@test "$clinom services seafile icon" {
  run "${clicmd}" services seafile icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services seafile cleanup" {
  run "${clicmd}" services seafile cleanup
  assert_success && assert_output -p 'cleaned up'
}
