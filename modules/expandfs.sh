#!/bin/bash

function expandfs () {
  # expandfs is way too complex, it should be handled by raspi-config
  raspi-config --expand-rootfs >/dev/null 2>/dev/null
  echo "Success: the filesystem will be expanded on the next reboot"
}

function expandfs_help {
  echo ""
  echo "Usage: $(basename "$0") expandfs"
  echo ""
  echo "Expands the partition of the raspberry pi image to use the whole disk"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") expandfs"
  echo "      The partition of the SD card in which the raspberry pi image is stored will be expanded to match the available space on the SD card after a reboot"
  echo ""
}