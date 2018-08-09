#!/bin/bash

function sshkeyadd () {
  mkdir -p /root/.ssh /home/pi/.ssh
  chmod 700 /root/.ssh /home/pi/.ssh

  echo "$@" >> /home/pi/.ssh/authorized_keys
  chmod 600 /home/pi/.ssh/authorized_keys
  chown -R pi:pi /home/pi/.ssh

  echo "$@" >> /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys

  echo "====== Added to 'pi' and 'root' user's authorized_keys ======"
  echo "$@"
}

function sshkeyadd_help () {
  echo ""
  echo "Usage: $(basename "$0") sshkeyadd <public_key>"
  echo ""
  echo "Adds a public key to 'pi' and 'root' user's authorized_keys"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") sshkeyadd \"\""
  echo "      The public key between quotes will be added to authorized_keys so user can login without password for both 'pi' and 'root' user."
  echo ""
}