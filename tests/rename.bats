#!/usr/bin/env bats
load test-helper

@test "$clinom rename (no arguments added)" {
  run "${clicmd}" rename
  assert_failure && assert_output -p 'Unsuccessful'
}

@test "$clinom rename (invalid characters)" {
  run "${clicmd}" rename -treehouses
  assert_failure && assert_output -p 'Unsuccessful'
}

@test "$clinom rename (too many characters)" {
  run "${clicmd}" rename treehousestreehousestreehousestreehousestreehousestreehousestreehouses
  assert_failure && assert_output -p 'Unsuccessful'
}

@test "$clinom rename (new name)" {
  run "${clicmd}" rename treehouses
  assert_success && assert_output -p 'Success'
}
