function bootoption {
  local option
  checkrpi
  checkroot
  checkargn $# 2
  option="$1"
  if [ "$option" = "console" ]; then
    systemctl set-default multi-user.target > "$LOGFILE"
    ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
    if [ -f "/etc/systemd/system/getty@tty1.service.d/autologin.conf" ]; then
      rm /etc/systemd/system/getty@tty1.service.d/autologin.conf
    fi
    reboot_needed
    echo "OK: A reboot is required to see the changes"
  elif [ "$option" = "console autologin" ]; then
    systemctl set-default multi-user.target > "$LOGFILE"
    ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
    cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $SUDO_USER --noclear %I $TERM
EOF
    reboot_needed
    echo "OK: A reboot is required to see the changes"
  elif [ "$option" = "desktop" ]; then
    if [ -e /etc/init.d/lightdm ]; then
      systemctl set-default graphical.target
      ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
      if [ -f "/etc/systemd/system/getty@tty1.service.d/autologin.conf" ]; then
        rm /etc/systemd/system/getty@tty1.service.d/autologin.conf
      fi
      sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/#autologin-user=/"
      reboot_needed
      echo "OK: A reboot is required to see the changes"
    else
      log_and_exit1 "Error: Do 'sudo apt-get install lightdm' to allow configuration of boot to desktop"
    fi
  elif [ "$option" = "desktop autologin" ]; then
    if [ -e /etc/init.d/lightdm ]; then
      systemctl set-default graphical.target
      ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
      cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $SUDO_USER --noclear %I $TERM
EOF
      sed /etc/lightdm/lightdm.conf -i -e "s/^\(#\|\)autologin-user=.*/autologin-user=$SUDO_USER/"
      reboot_needed
      echo "OK: A reboot is required to see the changes"
    else
      log_and_exit1 "Error: Do 'sudo apt-get install lightdm' to allow configuration of boot to desktop"
    fi
  elif [ "$option" = "modules" ]; then
    checkargn $# 1
    lsmod
  elif [ "$option" = "params" ]; then
    checkargn $# 1
    echo "$(</proc/cmdline)" | tr ' ' '\n' | sed '/^$/d'
  else
    log_and_exit1 "Error: only 'console', 'console autologin', 'desktop', 'desktop autologin', 'modules', 'params' options are supported."
  fi
}


function bootoption_help {
  echo
  echo "Usage: $BASENAME bootoption <modules|params|console|console autologin|desktop|desktop autologin>"
  echo
  echo "Changes the boot mode, to console or desktop"
  echo
  echo "Example:"
  echo "  $BASENAME bootoption console"
  echo "      The rpi will boot to console by default"
  echo
  echo "  $BASENAME bootoption console autologin"
  echo "      The rpi will boot to console by default and autologin in the user that run the command"
  echo
  echo "  $BASENAME bootoption desktop"
  echo "      The rpi will boot to desktop by default"
  echo
  echo "  $BASENAME bootoption desktop autologin"
  echo "      The rpi will boot to desktop by default and autologin in the user that run the command"
  echo
  echo "  $BASENAME bootoption params"
  echo "      Shows parameters the system booted with"
  echo
  echo "  $BASENAME bootoption modules"
  echo "      Shows modules the kernel loaded at boot"
  echo
}
