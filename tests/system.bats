#!/usr/bin/env bats
load test-helper

@test "$clinom system" {
    run "${clicmd}" system
    assert_success && assert_output -p 'CPU'
}

@test "$clinom system all" {
    run "${clicmd}" system all
    assert_success && assert_output -p 'CPU'
}

@test "$clinom system volt" {
    run "${clicmd}" system volt
    assert_success && assert_output -p 'Volt'
}

@test "$clinom system disk temperature" {
    run "${clicmd}" system disk temperature
    assert_success && assert_output -p 'Disk' && assert_output -p 'Temperature'
}

@test "$clinom system cputask" {
    run "${clicmd}" system cputask
    assert_success && assert_output -p 'CPU HEAVY TASKS'
}

@test "$clinom system error" {
    run "${clicmd}" system bruh lol
    assert_output -p 'Error'
}
