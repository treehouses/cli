#!/bin/bash

if [ -f "/etc/reboot-needed" ];
then
  rm -rf /etc/reboot-needed
fi