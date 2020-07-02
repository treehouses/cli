#!/usr/bin/env bats
load ../test-helper

@test "$clinom magazine magpi" {
  run "${clicmd}" magazine magpi
  assert_output -p "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
}

@test "$clinom magazine magpi language" {
  run "${clicmd}" magazine magpi language
  assert_success
}

@test "$clinom magazine magpi latest" {
  run "${clicmd}" magazine magpi latest
  assert_success
}

@test "$clinom magazine magpi all" {
  run "${clicmd}" magazine magpi all
  assert_success
}
