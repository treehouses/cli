#!/bin/bash
function cron {
  #option- add, list, edit, delete
  option="$1"
  cron_job_file=/tmp/treehouse_cron_job
  case "$option" in
      "add")
          # freq- hourly daily weekly monthly yearly
          freq="$2"
          # validate freq
          if [ "$freq" != "hourly" ] && [ "$freq" != "daily" ] \
              && [ "$freq" != "weekly" ] && [ "$freq" != "yearly" ] \
              && [ "$freq" != "monthly" ]; then
              cron_help
              exit 1
          fi
          cmd="$3"
          # validate cmd
          if [ -z "$cmd" ]; then
              crontab_help
              exit 1
          fi
          if crontab -l &>/dev/null; then
              crontab -l > $cron_job_file
          fi
          cron_entry="@$freq $cmd"
          echo "$cron_entry" >> $cron_job_file
          crontab $cron_job_file
          rm -f $cron_job_file
          echo "added '$cron_entry'"
          ;;
      "list")
          crontab -l
          ;;
      "delete")
          crontab -r
          echo "Cron job deleted."
          ;;
      "edit")
          crontab -e
          ;;
      *)
          cron_help
          exit 1
          ;;
  esac
}

function cron_help {
  echo
  echo "Usage: $(basename "$0") cron <add|list|edit|delete>"
  echo
  echo "Adds, lists, edits, or deletes cron jobs"
  echo
  echo "Options:"
  echo "  add <hourly|daily|weekly|monthly|yearly> <command>, add a cron job"
  echo "  list, list cron jobs."
  echo "  edit, edit cron jobs"
  echo "  delete, delete cron jobs"
  echo
  echo "Example:"
  echo "  # $(basename "$0") cron add yearly \"/bin/df -h >> /var/log/disk.log\""
  echo "  added '@yearly /bin/df -h >> /var/log/disk.log'"
  echo
  echo "  # $(basename "$0") cron list"
  echo "  @yearly /bin/df -h >> /var/log/disk.log"
  echo
  echo "  # $(basename "$0") cron edit"
  echo "  crontab: installing new crontab"
  echo
  echo "  # $(basename "$0") cron delete"
  echo "  Cron job deleted."
  echo
  echo
}
