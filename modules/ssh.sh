function ssh {
  local status
  checkroot
  status=$1
  case $status in
    "on")
      checkargn $# 1
      enable_service ssh
      start_service ssh
      echo "Success: the ssh service has been started and enabled when the system boots"
      ;;
    "off")
      checkargn $# 1
      disable_service ssh
      stop_service ssh
      echo "Success: the ssh service has been stopped and disabled when the system boots."
      ;;
    "fingerprint")
      checkargn $# 1
      ssh-keygen -l -E sha256 -f /etc/ssh/ssh_host_ecdsa_key.pub | cut -c5-54
      ;;
    "")
      last | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
      ;;
    "2fa" | "2FA")
      check_missing_packages "libpam-google-authenticator"
      case "$2" in
        "add" | "remove")
          if [ -z "$3" ]; then
            echo "Please specify the user."
          elif [ "$3" == "root" ]; then
            echo "You can't add or remove 2FA for root user."
            echo "You should only login as root user via a ssh key."
          elif cut -d: -f1 /etc/passwd | grep -q "$3"; then
            if [ "$2" == "add" ]; then
              echo "Adding 2FA for user $3..."
              runuser -l "$3" -c "google-authenticator"
              if [ ! -f "/home/$3/.google_authenticator" ]; then
                echo "Addtion for $3 user failed"
                exit 1
              fi
              ssh 2fa enable
            else
              rm -rf "/home/$3/.google_authenticator"
            fi
            exit 0
          else
            echo "No user as $3 found."
          fi
          exit 1 ;;
        "enable")
          if ! grep -q "auth required pam_google_authenticator.so nullok" /etc/pam.d/sshd; then
            echo "auth required pam_google_authenticator.so nullok" >> /etc/pam.d/sshd
          fi
          sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
          restart_service sshd
          enable_service sshd
          echo "ssh Two Factor Authentication enabled."
          ;;
        "disable")
          sed -i 's/auth required pam_google_authenticator.so nullok//g' /etc/pam.d/sshd
          sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
          restart_service sshd
          echo "ssh Two Factor Authentication disabled."
          ;;
        *)
          ssh_help
          ;;
      esac
      exit 0 ;;
    *)
      echo "Error: only '', 'on', 'off', or 'fingerprint' options are supported"
      ;;
  esac
}

function ssh_help {
  echo
  echo "Usage: $BASENAME ssh [on|off|fingerprint]"
  echo
  echo "Enables or disables the SSH service"
  echo
  echo "Example:"
  echo "  $BASENAME ssh"
  echo "      The last SSH connections from ipaddresses will be shown"
  echo
  echo "  $BASENAME ssh on"
  echo "      The SSH service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using SSH."
  echo
  echo "  $BASENAME ssh off"
  echo "      The SSH service will be disabled."
  echo 
  echo "  $BASENAME ssh fingerprint"
  echo "      The SSH fingerprint will be printed from when the session was first established."
  echo
  echo "  $BASENAME ssh 2FA add/remove <user>"
  echo "      Add/Remove a user for SSH with two factor authentication."
  echo
  echo "  $BASENAME ssh 2FA enable/disable"
  echo "      Enable/Disable two factor authentication for SSH service."
  echo
}
