#!/usr/bin/env bats
load ../test-helper

@test "$clinom services mariadb info" {
  run "${clicmd}" services mariadb info
  assert_success && assert_output -p 'https://mariadb.org/'
}

@test "$clinom services mariadb install" {
  run "${clicmd}" services mariadb install
  assert_success && assert_output -p 'installed'
}

@test "$clinom services mariadb up" {
  run "${clicmd}" services mariadb up
  sleep 5
  assert_success && assert_output -p 'mariadb built and started'
}

@test "$clinom services mariadb restart" {
  run "${clicmd}" services mariadb restart
  sleep 5
  assert_success && assert_output -p 'mariadb built and started'
}

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'mariadb'
}

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'mariadb'
}

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'jsurf/rpi-mariadb'
}

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'mariadb'
}

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'jsurf/rpi-mariadb'
}

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80'
}

@test "$clinom services mariadb port" {
  run "${clicmd}" services mariadb port
  assert_success && assert_output -p '3306'
}

@test "$clinom services mariadb ps" {
  run "${clicmd}" services mariadb ps
  assert_success && assert_output -p 'jsurf/rpi-mariadb'
}

@test "$clinom services mariadb url" {
  run "${clicmd}" services mariadb url
  assert_output -p '3306'
}

@test "$clinom services mariadb autorun" {
  run "${clicmd}" services mariadb autorun
  assert_success
}

@test "$clinom services mariadb autorun true" {
  run "${clicmd}" services mariadb autorun true
  assert_success && assert_output -p 'set to true'
}

@test "$clinom services mariadb stop" {
  run "${clicmd}" services mariadb stop
  assert_success && assert_output -p 'mariadb stopped'
}

@test "$clinom services mariadb start" {
  run "${clicmd}" services mariadb start
  assert_success && assert_output -p 'mariadb started'
}

@test "$clinom services mariadb down" {
  run "${clicmd}" services mariadb down
  assert_success && assert_output -p 'mariadb stopped and removed'
}

@test "$clinom services mariadb icon" {
  run "${clicmd}" services mariadb icon
  assert_success && assert_output -p 'svg'
}

@test "$clinom services mariadb cleanup" {
  run "${clicmd}" services mariadb cleanup
  assert_success && assert_output -p 'cleaned up'
}
