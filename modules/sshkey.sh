function sshkey () {
  local keys githubusername auth_files teams team_id members
  checkroot
  argument="$1"
  arg2="$2"

  case $argument in

    "add")
      checkargn $# 4
      shift
      temp_file=$(mktemp)
      echo "$@" >> $temp_file
      if ssh-keygen -l -f $temp_file 2>/dev/null <<< y >/dev/null; then
        rm $temp_file
        echo "$@" >> /root/.ssh/authorized_keys
        chmod 600 /root/.ssh/authorized_keys
        if [ "$(detectrpi)" != "nonrpi" ]; then
          mkdir -p /root/.ssh /home/pi/.ssh
          chmod 700 /root/.ssh /home/pi/.ssh
          echo "$@" >> /home/pi/.ssh/authorized_keys
          chmod 600 /home/pi/.ssh/authorized_keys
          chown -R pi:pi /home/pi/.ssh
          echo "====== Added to 'pi' and 'root' user's authorized_keys ======"
        else
          echo "====== Added to 'root' user's authorized_keys ======"
        fi
        echo "$@"
      else
        rm $temp_file
        log_and_exit1 "ERROR: invalid public key"
      fi
      ;;
    "list")
      checkargn $# 1
      echo "==== root keys ===="
      cat /root/.ssh/authorized_keys
      if [ "$(detectrpi)" != "nonrpi" ]; then
        echo "==== pi keys ===="
        cat /home/pi/.ssh/authorized_keys
      fi
      ;;
    "delete")
      checkargn $# 2
      if [ -z "$2" ]; then
        echo "Error: missing argument"
        log_and_exit1 "Usage: $BASENAME sshkey delete \"<key>\""
      fi
      keys="$(echo "$@" | sed 's/delete //')"
      if grep -Fxq "$keys" /root/.ssh/authorized_keys; then
        sed -i "\:$keys:d" /root/.ssh/authorized_keys
        echo "Key deleted from root keys."
      else
        echo "Key not found in root keys."
      fi
      if [ "$(detectrpi)" != "nonrpi" ]; then
        if grep -Fxq "$keys" /home/pi/.ssh/authorized_keys; then
          sed -i "\:$keys:d" /home/pi/.ssh/authorized_keys
          echo "Key deleted from pi keys."
        else
          echo "Key not found in pi keys."
        fi
      fi
      ;;
    "deleteall")
      checkargn $# 1
      rm /root/.ssh/authorized_keys
      if [ "$(detectrpi)" != "nonrpi" ]; then
        rm /home/pi/.ssh/authorized_keys
      fi
      echo "all sshkeys are deleted."
      ;;
    "github")

      case $arg2 in

        "")
          echo "Error: missing arguments"
          log_and_exit1 "Usage: $BASENAME sshkey github <adduser|deleteuser|addteam>"
          ;;
        "adduser")
          if [ -z "$3" ]; then
            echo "Error: missing argument"
            log_and_exit1 "Usage: $BASENAME sshkey adduser <username>"
          fi
          shift; shift
          for user in "$@"; do
            echo "  Attempting to add the following user: $user"
            keys=$(curl -s "https://github.com/$user.keys")
            if [ ! -z "$keys" ]; then
              keys=$(sed 's#$# '$user'#' <<< $keys)
              sshkey add "$keys"
            fi
            echo "  Successfully added user: $user"
          done
          ;;
        "deleteuser")
          if [ -z "$3" ]; then
            echo "Error: missing argument"
            log_and_exit1 "Usage: $BASENAME sshkey deleteuser <username>"
          fi
          githubusername="$3"
          auth_files="/root/.ssh/authorized_keys /home/pi/.ssh/authorized_keys"
          for file in $auth_files; do
            if [ -f "$file" ]; then
              if grep -q " $githubusername$" $file; then
                sed -i "/ $githubusername$/d" $file
                echo "$githubusername's key(s) deleted from $file"
              else
                echo "$githubusername does not exist"
              fi
            else
              echo "$file does not exist."
            fi
          done
          ;;
        "addteam")
          checkargn $# 5
          if [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
            echo "Error: missing arguments"
            log_and_exit1 "Usage: $BASENAME sshkey github addteam <organization> <team_name> <access_token>"
          fi
          teams=$(curl -s -X GET "https://api.github.com/orgs/$3/teams" -H "Authorization: token $5")
          team_id=$(echo "$teams" | jq ".[] | select(.name==\"$4\").id")
          members=$(curl -s -X GET "https://api.github.com/teams/$team_id/members" -H "Authorization: token $5" | jq ".[].login" -r)
          while read -r member; do
            sshkey github adduser "$member"
          done <<< "$members"
          ;;
        *)
          echo "Error: unsupported command"
          log_and_exit1 "Usage: $BASENAME sshkey github <adduser|deleteuser|addteam>"
          ;;
        esac
      *)
        echo "Error: unsupported command"
        log_and_exit1 "Usage: $BASENAME sshkey <add|list|delete|deleteall|github>"
        ;;
      esac
}

function sshkey_help () {
  echo
  echo "Usage: $BASENAME sshkey <add|list|delete|deleteall|github>"
  echo
  echo "Used for adding or removing ssh keys for authentication"
  echo
  echo "Example:"
  echo "  $BASENAME sshkey add \"\""
  echo "      The public key between quotes will be added to authorized_keys, so the user can login without a password for both 'pi' and 'root' user."
  echo
  echo "  $BASENAME sshkey list"
  echo "      Will output the content of the root and pi users keys"
  echo
  echo "  $BASENAME sshkey delete \"<key>\""
  echo "      Deletes the specified public key"
  echo
  echo "  $BASENAME sshkey deleteall"
  echo "      Deletes all ssh keys"
  echo
  echo "  $BASENAME sshkey github adduser|deleteuser <username>"
  echo "      Downloads or deletes the public keys of the github username from/to the authorized_keys file."
  echo
  echo "  $BASENAME sshkey github addteam <organization> <team_name> <access_token>"
  echo "      Downloads the public keys of the group members and adds them to authorized_keys"
  echo "      An access_token is required to make this work, it can be generated in the following link"
  echo "      https://github.com/settings/tokens"
  echo
}
