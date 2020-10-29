#!/bin/bash
# this file needs to be excuted on the base of the repo with `./templates/blocker/blocker.sh`

# Credits: https://github.com/StevenBlack/hosts
# The MIT License (MIT) Copyright © 2020 Steven Black
# https://github.com/StevenBlack/hosts/blob/master/license.txt
wget -q -O ./templates/blocker/1_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
wget -q -O ./templates/blocker/2_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts
wget -q -O ./templates/blocker/3_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-porn/hosts
wget -q -O ./templates/blocker/4_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts
wget -q -O ./templates/blocker/5_hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts
