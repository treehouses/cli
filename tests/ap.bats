#!/usr/bin/env bats
load test-helper

@test "$clinom ap local test123 (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap local test123
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap local test123 password (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap local test123 password
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap internet test321 (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap internet test321
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap internet test321 password (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap internet test321 password
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap internet test321 password --ip=192.168.2.24 (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap internet test321 password --ip=192.168.2.24
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}