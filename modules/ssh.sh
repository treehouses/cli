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
        "")
          if grep -q "auth required pam_google_authenticator.so nullok" /etc/pam.d/sshd; then
            echo "on"
          else
            echo "off"
          fi
          exit 0
          ;;
        "add" | "remove")
          if [ -z "$3" ]; then
            echo "Please specify the user."
          elif [ "$3" == "root" ]; then
            echo "You can't add or remove 2FA for root user."
            echo "You should only login as root user via a ssh key."
          elif cut -d: -f1 /etc/passwd | grep -q "$3"; then
            if [ "$2" == "add" ]; then
              if [ -f /home/$3/.google_authenticator ]; then
                echo "2FA for $3 already exists."
                echo "use \"treehouses ssh 2fa remove $3\" before generating a new one"
                exit 1
              fi
              if [ "$4" == "url" ]; then
                printf "y\ny\nn\ny\ny\n" | runuser -l "$3" -c "google-authenticator" |\
                  grep -o -E "https://.*$"
              elif [ "$4" == "interactive" ]; then
                runuser -l "$3" -c "google-authenticator"
              else
                echo "Adding 2FA for user $3..."
                printf "y\ny\nn\ny\ny\n" | runuser -l "$3" -c "google-authenticator"
              fi
              if [ ! -f "/home/$3/.google_authenticator" ]; then
                echo "Addition for user $3 failed."
                exit 1
              fi
              ssh 2fa enable > /dev/null
            else
              rm -rf "/home/$3/.google_authenticator"
            fi
          else
            echo "No user as $3 found."
            exit 1
          fi
          ;;
        "change")
          checkargn $# 3
          ssh 2fa remove $3
          ssh 2fa add $3
          exit 0 ;;
        "list")
          checkargn $# 2
          printf "%10s%10s\n" "USER" "STATUS"
          l=$(grep "^UID_MIN" /etc/login.defs)
          l1=$(grep "^UID_MAX" /etc/login.defs)
          for user in $(awk -F':' -v "min=${l##UID_MIN}" -v "max=${l1##UID_MAX}" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d: -f 1)
          do
            if [ -f "/home/$user/.google_authenticator" ]; then
              status="enabled"
            else
              status="disabled"
            fi
            printf "%10s%10s\n" "$user" "$status"
          done
          ;;
        "enable")
          checkargn $# 2
          if ! grep -q "auth required pam_google_authenticator.so nullok" /etc/pam.d/sshd; then
            echo "auth required pam_google_authenticator.so nullok" >> /etc/pam.d/sshd
          fi
          sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
          restart_service sshd
          enable_service sshd
          echo "ssh Two Factor Authentication enabled."
          ;;
        "disable")
          checkargn $# 2
          sed -i '\:auth required pam_google_authenticator.so nullok:d' /etc/pam.d/sshd
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
  echo "  $BASENAME ssh 2fa add/remove <user> [url|interactive]"
  echo "      Add/Remove a user for SSH with two factor authentication."
  echo
  echo "  $BASENAME ssh 2fa enable/disable"
  echo "      Enable/Disable two factor authentication for SSH service."
  echo
  echo "  $BASENAME ssh 2fa list"
  echo "      List ssh 2fa status of every user."
  echo
}
