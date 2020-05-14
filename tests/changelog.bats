#!/usr/bin/env bats
load test-helper

@test "$clinom changelog" {
  cp "/usr/lib/node_modules/@treehouses/cli/CHANGELOG.md" ../.
  run "${clicmd}" changelog
  assert_success
  rm "../CHANGELOG.md"
}