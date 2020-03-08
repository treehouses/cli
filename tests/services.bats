#!/usr/bin/env bats
load test-helper

@test "$clinom services available" {
  run "${clicmd}" services available
  assert_success && assert_output -p 'planet' }

@test "$clinom services available full" {
  run "${clicmd}" services available full
  assert_success && assert_output -p 'planet_yml' }

@test "$clinom services running" {
  run "${clicmd}" services running
  assert_success && assert_output -p 'planet' }

@test "$clinom services running full" {
  run "${clicmd}" services running full
  assert_success && assert_output -p 'treehouses/planet' }

@test "$clinom services installed" {
  run "${clicmd}" services installed
  assert_success && assert_output -p 'planet' }

@test "$clinom services installed full" {
  run "${clicmd}" services installed full
  assert_success && assert_output -p 'treehouses/planet' }

@test "$clinom services ports" {
  run "${clicmd}" services ports
  assert_success && assert_output -p 'port 80' }

@test "$clinom services planet info" {
  run "${clicmd}" services planet info
  assert_success && assert_output -p 'https://github.com/open-learning-exchange/planet' }

@test "$clinom services planet install" {
  run "${clicmd}" services planet install
  assert_success && assert_output -p 'installed' }

@test "$clinom services planet up" {
  run "${clicmd}" services planet up
  assert_success && assert_output -p 'planet built and started' }

@test "$clinom services planet port" {
  run "${clicmd}" services planet port
  assert_success && assert_output -p '80' }

@test "$clinom services planet ps" {
  run "${clicmd}" services planet ps
  assert_success && assert_output -p 'treehouses/planet' }

@test "$clinom services planet url both" {
  run "${clicmd}" services planet url both
  assert_success && assert_output -p '80' }

@test "$clinom services planet autorun" {
  run "${clicmd}" services planet autorun
  assert_success }

@test "$clinom services planet autorun true" {
  run "${clicmd}" services planet autorun true
  assert_success && assert_output -p 'set to true' }

@test "$clinom services planet stop" {
  run "${clicmd}" services planet stop
  assert_success && assert_output -p 'planet stopped' }

@test "$clinom services planet down" {
  run "${clicmd}" services planet down
  assert_success && assert_output -p 'planet stopped and removed' }