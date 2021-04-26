#!/usr/bin/env bats
load test-helper

@test "$clinom locale (no arguments added)" {
  run "${clicmd}" locale
  assert_failure &&  assert_output -p 'the locale is missing'
}

@test "$clinom locale en_US (supported argument)" {
  run "${clicmd}" locale en_US
  assert_success && assert_output -p 'locale has been changed'
}


@test "$clinom locale foo_BAR (non-supported argument added)" {
  run "${clicmd}" locale foo_BAR
  assert_failure && assert_output -p 'is not supported'
}
