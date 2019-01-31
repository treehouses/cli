#!/bin/bash

function sshkeyadd () {
  echo "NOTE: This command has been deprecated and will soon be replaced by `treehouses sshkey add`"
  sshkey add "$*"
}

function sshkeyadd_help () {
  echo ""
  echo "Usage: $(basename "$0") sshkeyadd <public_key>"
  echo ""
  echo "NOTE: This command has been deprecated and will soon be replaced by `treehouses sshkey add`"
  echo ""
  echo "Adds a public key to 'pi' and 'root' user's authorized_keys"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") sshkeyadd \"\""
  echo "      The public key between quotes will be added to authorized_keys so user can login without password for both 'pi' and 'root' user."
  echo ""
}