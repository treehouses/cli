#!/usr/bin/env bats
load ../test-helper

@test "$clinom services turtleblocksjs info" {
  run "${clicmd}" services turtleblocksjs info
  assert_success && assert_output -p 'https://github.com/treehouses/turtleblocksjs'
}

@test "$clinom services turtleblocksjs install" {
  run "${clicmd}" services turtleblocksjs install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services turtleblocksjs up" {
  run "${clicmd}" services turtleblocksjs up
  sleep 5
  assert_success && assert_output -p 'turtleblocksjs built and started'
}

@test "$clinom services turtleblocksjs restart" {
  run "${clicmd}" services turtleblocksjs restart
  sleep 5
  assert_success && assert_output -p 'turtleblocksjs built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'turtleblocksjs'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'turtleblocksjs'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/turtleblocksjs'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'turtleblocksjs'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/turtleblocksjs'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services turtleblocksjs port" {
  run "${clicmd}" services turtleblocksjs port
  assert_success && assert_output -p '8087'
}

@test "$clinom services turtleblocksjs ps" {
  run "${clicmd}" services turtleblocksjs ps
  assert_success && assert_output -p 'treehouses/turtleblocksjs'
}

@test "$clinom services turtleblocksjs url" {
  run "${clicmd}" services turtleblocksjs url
  assert_output -p '8087'
}

@test "$clinom services turtleblocksjs autorun" {
  run "${clicmd}" services turtleblocksjs autorun
  assert_success
}

@test "$clinom services turtleblocksjs autorun true" {
  run "${clicmd}" services turtleblocksjs autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services turtleblocksjs stop" {
  run "${clicmd}" services turtleblocksjs stop
  assert_success && assert_output -p 'turtleblocksjs stopped'
}

@test "$clinom services turtleblocksjs start" {
  run "${clicmd}" services turtleblocksjs start
  assert_success && assert_output -p 'turtleblocksjs started'
}

@test "$clinom services turtleblocksjs down" {
  run "${clicmd}" services turtleblocksjs down
  assert_success && assert_output -p 'turtleblocksjs stopped and removed'
}

@test "$clinom services turtleblocksjs icon" {
  run "${clicmd}" services turtleblocksjs icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services turtleblocksjs cleanup" {
  run "${clicmd}" services turtleblocksjs cleanup
  assert_success && assert_output -p 'cleaned up'
}
