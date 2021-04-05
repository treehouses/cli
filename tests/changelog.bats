#!/usr/bin/env bats
load test-helper

@test "$clinom changelog" {
  if [ ! -f "../CHANGELOG.md" ]; then
    cp "/usr/lib/node_modules/@treehouses/cli/CHANGELOG.md" ../.
    run "${clicmd}" changelog
    assert_success && rm "../CHANGELOG.md"
  else
    run "${clicmd}" changelog
    assert_success
  fi
}

@test "$clinom changelog view" {
  [ -e /usr/bin/view ] && [ -e /usr/lib/node_modules/@treehouses/cli/CHANGELOG.md ] # changelog view opens the log file in VIM read-only, this checks if view and changelog exists
  assert_success
}

@test "$clinom changelog compare (no version included)" {
  if [ ! -f "../CHANGELOG.md" ]; then
    cp "/usr/lib/node_modules/@treehouses/cli/CHANGELOG.md" ../.
    run "${clicmd}" changelog compare
    assert_failure && rm "../CHANGELOG.md"
  else
    run "${clicmd}" changelog compare
    assert_failure
  fi
}

@test "$clinom changelog compare old-version (one version provided)" {
  if [ ! -f "../CHANGELOG.md" ]; then
    cp "/usr/lib/node_modules/@treehouses/cli/CHANGELOG.md" ../.
    run "${clicmd}" changelog compare 1.0.0
    assert_success && rm "../CHANGELOG.md"
  else
    run "${clicmd}" changelog compare 1.0.0
    assert_success
  fi
}

@test "$clinom changelog compare old-version new-version (two versions provided)" {
  if [ ! -f "../CHANGELOG.md" ]; then
    cp "/usr/lib/node_modules/@treehouses/cli/CHANGELOG.md" ../.
    run "${clicmd}" changelog compare 1.0.0 1.0.1
    assert_success && rm "../CHANGELOG.md"
  else
    run "${clicmd}" changelog compare 1.0.0 1.0.1
    assert_success
  fi
}