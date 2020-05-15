#!/usr/bin/env bats
load test-helper

@test "$clinom services planet info" {
  run "${clicmd}" services planet info
  assert_success && assert_output -p 'https://github.com/open-learning-exchange/planet'
}

@test "$clinom services planet install" {
  run "${clicmd}" services planet install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services planet up" {
  run "${clicmd}" services planet up
  sleep 5
  assert_success && assert_output -p 'planet built and started'
}

@test "$clinom services planet restart" {
  run "${clicmd}" services planet restart
  sleep 5
  assert_success && assert_output -p 'planet built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'planet'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'planet'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/planet'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'planet'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/planet'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services planet port" {
  run "${clicmd}" services planet port
  assert_success && assert_output -p '80'
}

@test "$clinom services planet ps" {
  run "${clicmd}" services planet ps
  assert_success && assert_output -p 'treehouses/planet'
}

@test "$clinom services planet url" {
  run "${clicmd}" services planet url
  assert_output -p '80'
}

@test "$clinom services planet autorun" {
  run "${clicmd}" services planet autorun
  assert_success
}

@test "$clinom services planet autorun true" {
  run "${clicmd}" services planet autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services planet stop" {
  run "${clicmd}" services planet stop
  assert_success && assert_output -p 'planet stopped'
}

@test "$clinom services planet start" {
  run "${clicmd}" services planet start
  assert_success && assert_output -p 'planet started'
}

@test "$clinom services planet down" {
  run "${clicmd}" services planet down
  assert_success && assert_output -p 'planet stopped and removed'
}

@test "$clinom services planet icon" {
  run "${clicmd}" services planet icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services planet cleanup" {
  run "${clicmd}" services planet cleanup
  assert_success && assert_output -p 'cleaned up'
}
