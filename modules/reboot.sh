#!/bin/bash

function reboot () {
  case "$1" in
    "")
      echo "No timeframe selected" ; echo
      reboot_help
      ;;
    "now")
      echo "Rebooting now."
      reboot now
      ;;
    "in")
      echo "Rebooting in \"$2\". ctrl+c to cancel."
      sleep "$2" ; reboot now
      ;;
    "cron")
      #add user's cron job to crontab
      if [[ $(crontab -l | grep "$2 reboot now" ) != "$2" ]]; then
        (crontab -l ; echo "$2 reboot now") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
        echo "cron job with frequency \"$2\" added"
      elif [[ $(crontab -l | grep "$2") == "$2" ]]; then
        echo "cron job \"$2\" already established" ; echo "run \"$(basename "$0") help cron\" for cron commands"
      fi
      ;;
    "daily")
      echo "System will reboot daily at 00:00"
      (crontab -l ; echo "@daily reboot now") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
      ;;
    "weekly")
      echo "System will reboot weekly at 00:00"
      (crontab -l ; echo "@weekly reboot now") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
      ;;
    "monthly")
      echo "System will reboot monthly at 00:00"
      (crontab -l ; echo "@monthly reboot now") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
      ;;
    "*")
      echo "Invalid input"
      reboot_help
      ;;
  esac
}

function reboot_help {
  echo ""
  echo "  Usage: $(basename "$0") reboot <now|in|cron|daily|weekly|monthly>"
  echo ""
  echo "  Reboots system at selected time"
  echo ""
  echo "  Example:"
  echo "  $(basename "$0") reboot daily"
  echo "  System will reboot daily at 00:00"
  echo ""
  echo "  $(basename "$0") reboot in 120"
  echo "  System will reboot in 120 seconds. ctrl+c to cancel."
  echo ""
  echo "  $(basename "$0") reboot cron \"* * * * *\""
  echo "  cron job with frequency \"* * * * *\" added"
  echo ""
  echo "  Set frequency: * * * * *"
  echo "                 │ │ │ │ │"
  echo "                 │ │ │ │ └── day of the week    (* | #/# | 0 - 6 or Sun to Sat)"
  echo "                 │ │ │ └──── month              (* | #/# | 1 - 12)"
  echo "                 │ │ └────── day of the month   (* | #/# | 1 - 31)"
  echo "                 │ └──────── hour               (* | #/# | 0 - 23)"
  echo "                 └────────── minute             (* | #/# | 0 - 59)"
  echo ""
}
