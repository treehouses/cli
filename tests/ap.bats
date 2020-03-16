#!/usr/bin/env bats
load test-helper

@test "$clinom ap local test1 (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap local test1
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap local test2 password (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap local test2 password
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap internet test3 (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap internet test3
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap internet test4 password (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap internet test4 password
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}

@test "$clinom ap internet test5 password --ip=192.168.2.24 (check ap...press any key to continue)" {
  check_networkmode
  run "${clicmd}" ap internet test5 password --ip=192.168.2.24
  assert_success && assert_output -p 'This pirateship has anchored successfully!'
  read -n 1 -s -r
}
