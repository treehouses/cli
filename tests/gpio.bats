#!/usr/bin/env bats
load test-helper

@test "$clinom gpio" {
  run "${clicmd}" gpio
  assert_success && assert_output -p "3V3  (1) (2)  5V" && assert_output -p "GPIO2  (3) (4)  5V" && assert_output -p "GPIO3  (5) (6)  GND" && assert_output -p "GPIO4  (7) (8)  GPIO14" && assert_output -p "GND  (9) (10) GPIO15" && assert_output -p "GPIO17 (11) (12) GPIO18" && assert_output -p "GPIO27 (13) (14) GND" && assert_output -p "GPIO22 (15) (16) GPIO23" && assert_output -p "3V3 (17) (18) GPIO24" && assert_output -p "GPIO10 (19) (20) GND" && assert_output -p "GPIO9 (21) (22) GPIO25" && assert_output -p "GPIO11 (23) (24) GPIO8" && assert_output -p "GND (25) (26) GPIO7" && assert_output -p "GPIO0 (27) (28) GPIO1" && assert_output -p "GPIO5 (29) (30) GND" && assert_output -p "GPIO6 (31) (32) GPIO12" && assert_output -p "GPIO13 (33) (34) GND" && assert_output -p "GPIO19 (35) (36) GPIO16" && assert_output -p "GPIO26 (37) (38) GPIO20" && assert_output -p "GND (39) (40) GPIO21"
}
