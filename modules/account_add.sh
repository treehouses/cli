#!/bin/bash

add_account () {
  local account="$1"
  local password="$2"

  useradd "$account"
  [ $(usermod -aG sudo "$account") ] && echo "User $account is generated"
  mkdir -p "/home/$account"
}
