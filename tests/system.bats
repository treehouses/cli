#!/usr/bin/env bats
load test-helper

@test "$clinom system" {
    run "${clicmd}" system
    assert_success && assert_output -p 'CPU:' \
    && assert_output -p "Memory:" \
    && assert_output -p "Disk storage:" \
    && assert_output -p "Volt:" \
    && assert_output -p "Temperature:" \
    && assert_output -p "CPU HEAVY TASKS" \
    && assert_output -p "RAM HEAVY TASKS"
}

@test "$clinom system all" {
    run "${clicmd}" system all
    assert_success && assert_output -p 'CPU:' \
    && assert_output -p "Memory:" \
    && assert_output -p "Disk storage:" \
    && assert_output -p "Volt:" \
    && assert_output -p "Temperature:" \
    && assert_output -p "CPU HEAVY TASKS" \
    && assert_output -p "RAM HEAVY TASKS"
}

@test "$clinom system volt" {
    run "${clicmd}" system volt
    assert_success && assert_output -p 'Volt:'
}

@test "$clinom system disk temperature" {
    run "${clicmd}" system disk temperature
    assert_success && assert_output -p 'Disk storage:' && assert_output -p 'Temperature:'
}

@test "$clinom system cputask" {
    run "${clicmd}" system cputask
    assert_success && assert_output -p 'CPU HEAVY TASKS'
}

@test "$clinom system ramtask" {
    run "${clicmd}" system ramtask
    assert_success && assert_output -p 'RAM HEAVY TASKS'
}

@test "$clinom system error" {
    run "${clicmd}" system bruh lol
    assert_output -p 'Error'
}
