#!/bin/bash

if [ -f "/etc/reboot-required" ];
then
  rm -rf /etc/reboot-required
fi