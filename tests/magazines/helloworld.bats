#!/usr/bin/env bats
load ../test-helper

@test "$clinom magazines helloworld" {
  run "${clicmd}" magazines helloworld
  assert_output -p "HelloWorld is the computing and digital making magazine for educators."
}

@test "$clinom magazines helloworld url" {
  run "${clicmd}" magazines helloworld url
  assert_output -p "https://helloworld.raspberrypi.org/issues"
}

@test "$clinom magazines helloworld list" {
  run "${clicmd}" magazines helloworld list
  assert_success
}

@test "$clinom magazines helloworld latest" {
  run "${clicmd}" magazines helloworld latest
  assert_success
}

@test "$clinom magazines helloworld all" {
  run "${clicmd}" magazines helloworld all
  assert_success
}
