#!/usr/bin/env bats
load ../test-helper

@test "$clinom magazines magpi" {
  run "${clicmd}" magazines magpi
  assert_output -p "The MagPi is The Official Raspberry Pi magazine. Written by and for the community, it is packed with Raspberry Pi-themed projects, computing and electronics tutorials, how-to guides, and the latest news and reviews."
}

@test "$clinom magazines magpi url" {
  run "${clicmd}" magazines magpi url
  assert_output -p "https://magpi.raspberrypi.org/issues"
}

@test "$clinom magazines magpi list" {
  run "${clicmd}" magazines magpi list
  assert_success
}

@test "$clinom magazines magpi latest" {
  run "${clicmd}" magazines magpi latest
  assert_success
}

@test "$clinom magazines magpi all" {
  run "${clicmd}" magazines magpi all
  assert_success
}
