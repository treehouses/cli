function remote {
  local results
  checkroot
  checkrpi
  option="$1"

  case $option in
    "check")
      checkargn $# 1
      echo "$(bluetooth mac) $(image) $(version) $(detectrpi)"
      ;;
    "status")
      checkargn $# 1
      echo "$(internet) $(bluetooth mac) $(image) $(version) $(detectrpi)"
      ;;
    "upgrade")
      checkargn $# 1
      upgrade --check
      ;;
    "services")
      checkargn $# 2
      case "$2" in
        "available")
          results="Available: $(services available)"
          echo $results
          ;;
        "installed")
          results="Installed: $(services installed)"
          echo $results
          ;;
        "running")
          results="Running: $(services running)"
          echo $results
          ;;
        *)
          echo "Error: incorrect command"
          log_and_exit1 "Usage: $BASENAME remote services <available | installed | running>"
          ;;
      esac
      ;;
    "version")
      checkargn $# 2
      if [ -z "$2" ]; then
        echo "Error: version number required"
        log_and_exit1 "Usage: $BASENAME remote version <version_number>"
      fi
      if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        log_and_exit1 "Error: not a number"
      fi
      if [ "$2" -ge "$(node -p "require('$SCRIPTFOLDER/package.json').remote")" ]; then
        echo "version: true"
      else
        echo "version: false"
      fi
      ;;
    "commands")
      checkargn $# 2
      source $SCRIPTFOLDER/_treehouses && _treehouses_complete 2>/dev/null
      if [ -z "$2" ]; then
        echo "$every_command"
      elif [ "$2" = "json" ]; then
        while IFS= read -r line;
        do
          cmd_str+="\"$line\","
        done <<< "$every_command"
        printf "{\"commands\":["%s"]}\n" "${cmd_str::-1}"
      else
        echo "Error: incorrect command"
        log_and_exit1 "Usage: $BASENAME remote commands [json]"
      fi
      ;;
    "reverse")
      checkargn $# 2
      reverse=$(internet reverse | sed -e 's#",\ "#"\n"#g' | cut -d'"' -f 2,3,4 | sed 's#\:[[:space:]]\"#:\"#g' | awk '!x[$0]++')
      IP=$(echo $reverse | grep -o -P '(?<=,).*(?=,)')
      echo $IP
        while IFS= read -r line; do
          cmd_str+="\"$line\","
        done <<< "$reverse"
        printf "{%s}\n" "${cmd_str::-1}"
      ;;
    "allservices")
      checkargn $# 1
      json_fmt="{\"available\":["%s"],\"installed\":["%s"],\"running\":["%s"],\"icon\":{"%s"},\"info\":{"%s"},\"autorun\":{"%s"},\"usesEnv\":{"%s"},\"size\":{"%s"}}\n"

      available_str=$(services available | sed 's/^\|$/"/g' | paste -d, -s)
      installed_str=$(services installed | sed 's/^\|$/"/g' | paste -d, -s)
      running_str=\"$(services running | tr ' ' ',')\"
      running_str=${running_str//,/\",\"}

      available=($(services available))
      for i in "${available[@]}"
      do
        icon_str+="\"$i\":\"$(source $SERVICES/install-$i.sh && get_icon | sed 's/^[ \t]*//;s/[ \t]*$//' | tr '\n' ' ' | sed 's/"/\\"/g')\","
        info_str+="\"$i\":\"$(source $SERVICES/install-$i.sh && get_info | tr '\n' ' ' | sed 's/"/\\"/g')\","
        autorun_str+="\"$i\":\"$(autorun_helper $i)\","
        env_str+="\"$i\":\"$(source $SERVICES/install-$i.sh && uses_env)\","
        size_str+="\"$i\":\"$(source $SERVICES/install-$i.sh && get_size)\","
      done

      printf "$json_fmt" "$available_str" "$installed_str" "$running_str" "${icon_str::-1}" "${info_str::-1}" "${autorun_str::-1}" "${env_str::-1}" "${size_str::-1}"
      ;;
    "statuspage")
      countryonly=$(wificountry)
      checkargn $# 1
      json_statusfmt="{\"status\":\"$(remote status)\",\"hostname\":\"$(hostname)\",\"arm\":\"$(detect arm)\",\"internet\":\"$(internet)\",\"memory_total\":\"$(memory total gb)\",\"memory_used\":\"$(memory used gb)\",\"temperature\":\"$(temperature)\",\"networkmode\":\"$(networkmode)\",\"info\":\"$(networkmode info | tr '\n' ' ')\",\"storage\":\"$(system disk | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/ \{1,\}/ /g;s/[[:space:]]*$//')\",\"wificountry\":\"${countryonly:8}\"}"

      printf '%s\n' "${json_statusfmt}"
      ;;
    "ssh2fa")
      checkargn $# 1
      users=$(cat /etc/passwd | grep "/home" | cut -d: -f1)
      for user in ${users[@]};
      do
        showuser=$(ssh 2fa show $user)
        if [[ "$showuser" == "SSH 2FA for $user is disabled." ]]; then
          outputpart="\"$user\":\"disabled\","
        else        
          secret="$(echo "$showuser" | head -n 1 | sed 's/Secret Key://g' | sed -r 's/\s+//g')"
          scratch="$(echo "$showuser" | awk 'NR>3' | sed 's/.*/"&"/' | awk '{printf "%s"",",$0}' | sed 's/,$//')"
          outputpart="\"$user\":{\"secret key\":\"$secret\",\"scratch codes\":[$scratch]},"
        fi
        output="$output$outputpart"
      done      
      echo "{${output::-1}}"
      ;;
    "help")
      json_var=$(jq -n --arg desc "$(source $SCRIPTFOLDER/modules/help.sh && help)" '{"help":$desc}')
      for file in $SCRIPTFOLDER/modules/*.sh
      do
        command=${file##*/}
        command=${command%.*}
        if [ "$command" != "help" ]; then
          if [ "$command" != "detectrpi" ] && [ "$command" != "globals" ]; then
            json_var=$(echo $json_var | jq --arg key "$command" --arg desc "$(source $file && ${command}_help)" '. += {($key):($desc)}')
          fi
        fi
      done
      echo ${json_var}
      ;;
    "key")
      case "$2" in
        send)
          checkargn $# 3
          profile=$3
          public_key=$(sshtunnel key send public $profile)
          private_key=$(sshtunnel key send private $profile | tr '\n' ' ') 

          if [ -z "$profile" ]; then
            profile="default"
          fi

          jq -n "{profile:\"$profile\", public_key:\"$public_key\", private_key:\"$private_key\"}"
          ;;
        receive)
          checkargn $# 5
          public_key=$3
          private_key=$4
          profile=$5

          if [ -z "$public_key" ]; then
            echo "Error: public key required"
            log_and_exit1 "Usage: $BASENAME remote key receive \"\$public_key\" \"\$private_key\" [profile]"
          elif [ -z "$private_key" ]; then
            echo "Error: private key required"
            log_and_exit1 "Usage: $BASENAME remote key receive \"\$public_key\" \"\$private_key\" [profile]"
          else
            sshtunnel key receive public "$public_key" "$profile"
            sshtunnel key receive private "$private_key" "$profile"
          fi
          ;;
        *)
          echo "Error: incorrect command"
          log_and_exit1 "Usage: $BASENAME remote key <send | receive>"
          ;;
      esac
      ;;
    *)
      echo "Unknown command option"
      echo "Usage: $BASENAME remote <check | status | upgrade | services | version | commands | reverse | allservices | statuspage | ssh2fa | help | key>"
      ;;
  esac
}

function autorun_helper {
  if [ ! -f /boot/autorun ]; then
    echo "false"
  else
    found=false
    while read -r line; do
      if [[ $line == "${1}_autorun=true" ]]; then
        found=true
        break
      fi
    done < /boot/autorun
    if [ "$found" = true ]; then
      echo "true"
    else
      echo "false"
    fi
  fi
}

function remote_help {
  echo
  echo "Usage: $BASENAME remote <check | status | upgrade | services | version | commands | reverse | allservices | statuspage | ssh2fa | help | key>"
  echo
  echo "Returns a string representation of the current status of the Raspberry Pi"
  echo "Used for Treehouses Remote"
  echo
  echo "$BASENAME remote check"
  echo "<bluetooth mac> <image> <version> <detectrpi>"
  echo "     │            │           │        │"
  echo "     │            │           │        └── model number of rpi"
  echo "     │            │           └─────────── current cli version"
  echo "     │            └─────────────────────── current treehouses image version"
  echo "     └──────────────────────────────────── bluetooth mac address"
  echo
  echo "$BASENAME remote status"
  echo "<internet> <bluetooth mac> <image> <version> <detectrpi>"
  echo "     │            │           │        │          │"
  echo "     │            │           │        │          └── model number of rpi"
  echo "     │            │           │        └───────────── current cli version"
  echo "     │            │           └────────────────────── current treehouses image version"
  echo "     │            └────────────────────────────────── bluetooth mac address"
  echo "     └─────────────────────────────────────────────── internet connection status"
  echo
  echo "$BASENAME remote upgrade"
  echo "true if an upgrade is available"
  echo "false otherwise"
  echo
  echo "$BASENAME remote services <available | installed | running>"
  echo "Available: | Installed: | Running: <list of services>"
  echo
  echo "$BASENAME remote version <version_number>"
  echo "true if <version_number> >= \"remote_min_version\" in package.json"
  echo "false otherwise"
  echo
  echo "$BASENAME remote commands [json]"
  echo "returns a list of all commands for tab completion"
  echo
  echo "$BASENAME remote reverse"
  echo "returns the device's internet location information"
  echo
  echo "$BASENAME remote allservices"
  echo "returns json string of services"
  echo
  echo "$BASENAME ssh ssh2fa"
  echo "outputs json format of all users' 2fa secret keys and scratch codes."
  echo
  echo "$BASENAME remote help"
  echo "returns json string of help for all modules"
  echo
  echo "$BASENAME remote key send [profile]"
  echo "returns json of public and private key for [profile]"
  echo
  echo "$BASENAME remote key receive \"\$public_key\" \"\$private_key\" [profile]"
  echo "saves \"\$public_key\" and \"\$private_key\" for [profile]"
  echo
}
