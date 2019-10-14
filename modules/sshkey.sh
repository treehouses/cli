#!/bin/bash

function sshkey () {
  if [ "$1" == "add" ]; then
    shift
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
  elif [ "$1" == "list" ]; then
    echo "==== root keys ===="
    cat /root/.ssh/authorized_keys
    if [ "$(detectrpi)" != "nonrpi" ]; then
      echo "==== pi keys ===="
      cat /home/pi/.ssh/authorized_keys
    fi
  elif [ "$1" == "delete" ]; then
    if [[ "$2" == "" ||  "$2" == "ssh-rsa" ]]; then
      echo "Error: missing argument"
      echo "Usage: $(basename "$0") sshkey delete \"<key>\""
      exit 1
    fi  
    sed -i "\|$2|d" /root/.ssh/authorized_keys
    if [ "$(detectrpi)" != "nonrpi" ]; then
      sed -i "\|$2|d" /home/pi/.ssh/authorized_keys
    fi
    echo "$2 is deleted."
  elif [ "$1" == "deleteall" ]; then
    rm /root/.ssh/authorized_keys
    if [ "$(detectrpi)" != "nonrpi" ]; then
      rm /home/pi/.ssh/authorized_keys
    fi
    echo "all sshkeys are deleted."
  elif [ "$1" == "addgithubusername" ]; then
    if [ -z "$2" ]; then
      echo "Error: missing argument"
      echo "Usage: $(basename "$0") sshkey addgithubusername <username>"
      exit 1
    fi
    keys=$(curl -s "https://github.com/$2.keys")
    if [ ! -z "$keys" ]; then
      keys=$(sed 's#$# '$2'#' <<< $keys)
      sshkey add "$keys"
    fi
  elif [ "$1" == "addgithubgroup" ]; then
    if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
      echo "Error: missing arguments"
      echo "Usage: $(basename "$0") sshkey addgithubgroup <organization> <team_name> <access_token>"
      exit 1
    fi
    teams=$(curl -s -X GET "https://api.github.com/orgs/$2/teams" -H "Authorization: token $4")
    team_id=$(echo "$teams" | jq ".[] | select(.name==\"$3\").id")
    members=$(curl -s -X GET "https://api.github.com/teams/$team_id/members" -H "Authorization: token $4" | jq ".[].login" -r)
    while read -r member; do
      sshkey addgithubusername "$member"
    done <<< "$members"
  fi
}

function sshkey_help () {
  echo ""
  echo "Usage: $(basename "$0") sshkey <add|list|delete|addgithubusername|addgithubgroup>"
  echo ""
  echo "Used for adding or removing ssh keys for authentication"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") sshkey add \"\""
  echo "      The public key between quotes will be added to authorized_keys so user can login without password for both 'pi' and 'root' user."
  echo ""
  echo "  $(basename "$0") sshkey list"
  echo "      Will output the content of the root and pi users keys"
  echo ""
  echo "  $(basename "$0") sshkey delete \"<key>\""
  echo "      Deletes the specified public key"
  echo ""
  echo "  $(basename "$0") sshkey deleteall"
  echo "      Deletes all ssh keys"
  echo ""
  echo "  $(basename "$0") sshkey addgithubusername <username>"
  echo "      Downloads the public keys of the github username and adds them to authorized_keys"
  echo ""
  echo "  $(basename "$0") sshkey addgithubgroup <organization> <team_name> <access_token>"
  echo "      Downloads the public keys of the group members and adds them to authorized_keys"
  echo "      A access_token is required to make this work, it can be generated in the following link"
  echo "      https://github.com/settings/tokens"
  echo ""
}
