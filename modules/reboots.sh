function reboots {
  case "$1" in
    "")
      logit "No timeframe selected. For how to use \"reboots\" run: $BASENAME help reboots"
      echo ; logit "Tasks scheduled:"
      crontab -l
      ;;
    "now")
      logit "Rebooting now."
      sudo reboot
      ;;
    "in")
      logit "Rebooting in \"$2\". ctrl+c to cancel."
      sleep "$2" ; sudo reboot
      ;;
    "cron")
      if [[ $(crontab -l | grep "$2" ) != "$2 reboot" ]]; then
        (crontab -l ; echo "$2 reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        logit "Rebooting with frequency of \"$2\" added"
      elif [[ $(crontab -l | grep "$2") == "$2 reboot" ]]; then
        logit "Reboot frequency of \"$2\" already established"
        logit "To delete it, use: $BASENAME cron delete \"$2\""
      else
        reboots_help
      fi
      ;;
    "daily")
      if [[ $(crontab -l | grep "@daily") != "@daily reboot" ]]; then
        (crontab -l ; echo "@daily reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        logit "System will reboot daily at 00:00"
      elif [[ $(crontab -l | grep "@daily") == "@daily reboot" ]]; then
        (crontab -l ; echo "@daily reboot") 2>&1 | grep -v "no crontab" | grep -v "@daily" | sort | uniq | crontab -
        logit "Job to reboot daily removed"
      else
        reboots_help
      fi
      ;;
    "weekly")
      if [[ $(crontab -l | grep "@weekly") != "@weekly reboot" ]]; then
        (crontab -l ; echo "@weekly reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        logit "System will reboot at 00:00 every Sunday"
      elif [[ $(crontab -l | grep "@weekly") == "@weekly reboot" ]]; then
        (crontab -l ; echo "@weekly reboot") 2>&1 | grep -v "no crontab" | grep -v "@weekly" | sort | uniq | crontab -
        logit "Job to reboot weekly removed"
      else
        reboots_help
      fi
      ;;
    "monthly")
      if [[ $(crontab -l | grep "@monthly") != "@monthly reboot" ]]; then
        (crontab -l ; echo "@monthly reboot") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        logit "System will reboot at 00:00 on the 1st of every month"
      elif [[ $(crontab -l | grep "@monthly") == "@monthly reboot" ]]; then
        (crontab -l ; echo "@monthly reboot") 2>&1 | grep -v "no crontab" | grep -v "@monthly" | sort | uniq | crontab -
        logit "Job to reboot monthly removed"
      else
        reboots_help
      fi
      ;;
    "*")
      logit "Invalid input"
      reboots_help
      ;;
  esac
}

function reboots_help {
  echo
  echo "  Usage: $BASENAME reboots <now|in|cron|daily|weekly|monthly>"
  echo
  echo "  Reboots system at selected time and removes it if reboot task already active"
  echo
  echo "  Example:"
  echo "  $BASENAME reboots daily"
  echo "  System will reboot daily at 00:00"
  echo
  echo "  $BASENAME reboots in 120"
  echo "  System will reboot in 120 seconds. ctrl+c to cancel."
  echo
  echo "  $BASENAME reboots cron \"0 * * * *\""
  echo "  Rebooting with frequency of \"0 * * * *\" added"
  echo
  echo "  Set frequency: * * * * *"
  echo "                 │ │ │ │ │"
  echo "                 │ │ │ │ └── day of the week    (* | #/# | 0 - 6 or Sun to Sat)"
  echo "                 │ │ │ └──── month              (* | #/# | 1 - 12)"
  echo "                 │ │ └────── day of the month   (* | #/# | 1 - 31)"
  echo "                 │ └──────── hour               (* | #/# | 0 - 23)"
  echo "                 └────────── minute             (* | #/# | 0 - 59)"
  echo
}
