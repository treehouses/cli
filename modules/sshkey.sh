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
    if [ -z "$2" ]; then
      echo "Error: missing argument"
      echo "Usage: $BASENAME sshkey delete \"<key>\""
      exit 1
    fi
    if [ "$2" == "ssh-rsa" ]; then
      echo "Error: missing qoutes"
      echo "Usage: $BASENAME sshkey delete \"<key>\""
      exit 1
    fi
    if grep -Fxq "$2" /root/.ssh/authorized_keys; then
      sed -i "\:$2:d" /root/.ssh/authorized_keys
      echo "Key deleted from root keys."
    else
      echo "Key not found in root keys."
    fi
    if [ "$(detectrpi)" != "nonrpi" ]; then
      if grep -Fxq "$2" /home/pi/.ssh/authorized_keys; then
        sed -i "\:$2:d" /home/pi/.ssh/authorized_keys
        echo "Key deleted from pi keys."
      else
        echo "Key not found in pi keys."
      fi
    fi
  elif [ "$1" == "deleteall" ]; then
    rm /root/.ssh/authorized_keys
    if [ "$(detectrpi)" != "nonrpi" ]; then
      rm /home/pi/.ssh/authorized_keys
    fi
    echo "all sshkeys are deleted."
  elif [ "$1" == "github" ]; then
    if [ -z "$2" ]; then
      echo "Error: missing arguments"
      echo "Usage: $BASENAME sshkey github <adduser|deleteuser|addteam>"
      exit 1
    fi
    if [ "$2" == "adduser" ]; then
      if [ -z "$3" ]; then
        echo "Error: missing argument"
        echo "Usage: $BASENAME sshkey adduser <username>"
        exit 1
      fi
      keys=$(curl -s "https://github.com/$3.keys")
      if [ ! -z "$keys" ]; then
        keys=$(sed 's#$# '$3'#' <<< $keys)
        sshkey add "$keys"
      fi
    elif [ "$2" == "deleteuser" ]; then
      if [ -z "$3" ]; then
        echo "Error: missing argument"
        echo "Usage: $BASENAME sshkey deleteuser <username>"
        exit 1
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
    elif [ "$2" == "addteam" ]; then
      if [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
        echo "Error: missing arguments"
        echo "Usage: $BASENAME sshkey github addteam <organization> <team_name> <access_token>"
        exit 1
      fi
      teams=$(curl -s -X GET "https://api.github.com/orgs/$3/teams" -H "Authorization: token $5")
      team_id=$(echo "$teams" | jq ".[] | select(.name==\"$4\").id")
      members=$(curl -s -X GET "https://api.github.com/teams/$team_id/members" -H "Authorization: token $5" | jq ".[].login" -r)
      while read -r member; do
        sshkey github adduser "$member"
      done <<< "$members"
    fi
#DEPRECATED####
  elif [ "$1" == "addgithubusername" ]; then
    if [ -z "$2" ]; then
      echo "Error: missing argument"
      echo "Usage: $BASENAME sshkey addgithubusername <username>"
      exit 1
    fi
    keys=$(curl -s "https://github.com/$2.keys")
    if [ ! -z "$keys" ]; then
      keys=$(sed 's#$# '$2'#' <<< $keys)
      sshkey add "$keys"
    fi
#############
#DEPRECATED####
  elif [ "$1" == "deletegithubusername" ]; then
    if [ -z "$2" ]; then
      echo "Error: missing argument"
      echo "Usage: $BASENAME sshkey deletegithubusername \"<username>\""
      exit 1
    fi
    githubusername="$2"
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
###############
#DEPRECATED####
  elif [ "$1" == "addgithubgroup" ]; then
    if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
      echo "Error: missing arguments"
      echo "Usage: $BASENAME sshkey addgithubgroup <organization> <team_name> <access_token>"
      exit 1
    fi
    teams=$(curl -s -X GET "https://api.github.com/orgs/$2/teams" -H "Authorization: token $4")
    team_id=$(echo "$teams" | jq ".[] | select(.name==\"$3\").id")
    members=$(curl -s -X GET "https://api.github.com/teams/$team_id/members" -H "Authorization: token $4" | jq ".[].login" -r)
    while read -r member; do
      sshkey addgithubusername "$member"
    done <<< "$members"
###############
  fi
}
function sshkey_help () {
  echo
  echo "Usage: $BASENAME sshkey <add|list|delete|addgithubusername|addgithubgroup>"
  echo
  echo "Used for adding or removing ssh keys for authentication"
  echo
  echo "Example:"
  echo "  $BASENAME sshkey add \"\""
  echo "      The public key between quotes will be added to authorized_keys so user can login without password for both 'pi' and 'root' user."
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
  echo "      A access_token is required to make this work, it can be generated in the following link"
  echo "      https://github.com/settings/tokens"
  echo
  echo "  $BASENAME sshkey addgithubusername <username>"
  echo "      (DEPRECATED) Downloads the public keys of the github username and adds them to authorized_keys"
  echo
  echo "  $BASENAME sshkey deletegithubusername <username>"
  echo "      (DEPRECATED) Deletes all ssh keys related to this user"
  echo
  echo "  $BASENAME sshkey addgithubgroup <organization> <team_name> <access_token>"
  echo "      (DEPRECATED) Downloads the public keys of the group members and adds them to authorized_keys"
  echo "      A access_token is required to make this work, it can be generated in the following link"
  echo "      https://github.com/settings/tokens"
  echo
}
