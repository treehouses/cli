#!/bin/bash
# Credits: https://github.com/StevenBlack/hosts
# The MIT License (MIT) Copyright © 2020 Steven Black
# https://github.com/StevenBlack/hosts/blob/master/license.txt
(cd $1 && ./blocker.sh)
wget -q -O 1_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
wget -q -O 2_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts
wget -q -O 3_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts
wget -q -O 4_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
wget -q -O 5_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts
