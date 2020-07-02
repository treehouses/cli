#!/usr/bin/env bats
load ../test-helper

@test "$clinom magazine helloworld" {
  run "${clicmd}" magazine helloworld
  assert_output -p "HelloWorld is the computing and digital making magazine for educators."
}

@test "$clinom magazine helloworld language" {
  run "${clicmd}" magazine helloworld language
  assert_success
}

@test "$clinom magazine helloworld latest" {
  run "${clicmd}" magazine helloworld latest
  assert_success
}

@test "$clinom magazine helloworld all" {
  run "${clicmd}" magazine helloworld all
  assert_success
}
