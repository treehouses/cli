#!/bin/bash
function cron {
  option="$1"
  #option- add, list, delete, deleteall
  cron_job_file=/etc/cron.d/treehouses
  case "$option" in
      "add")
         freq="$2"
         # freq- hourly daily weekly monthly yearly
         cmd="$3"
         #validate cmd
         if [ -z "$cmd" ]; then
             cron_help
             exit 1
         fi
         # minutes hours days months weeks
         # e.g hourly "30 * * * * root /home/pi/backup.sh >> /home/pi/backup.log"
         schedule=""
         case "$freq" in
             "hourly")
                 schedule="30 * * * *"
                 ;;
             "daily")
                 schedule="30 0 * * *"
                 ;;
             "monthly")
                 schedule="30 0 1 * *"
                 ;;
             "weekly")
                 schedule="30 0 * * 6"
                 ;;
             "yearly")
                 schedule="30 0 1 1 *"
                 ;;
             *)
                 cron_help
                 exit 1
                 ;;
         esac
         cron_entry="$schedule root $cmd"
         echo "$cron_entry" >> $cron_job_file
         echo "added '$cron_entry'"
         ;;
          
      "list")
         if [ -f $cron_job_file ]; then
            echo "ID --- CRON JOB"
            id=1
            while read -r entry; do
                echo "$id - $entry"
                id=$((id + 1))
            done < $cron_job_file
         else
             echo "No cron job found"
         fi
         ;;
      "delete")
          if [ -f $cron_job_file ]; then
              id=$2
              max_id="$(wc -l < $cron_job_file)"
              if [ $id -eq 0 ] || [ $id -gt $max_id ]; then
                  echo "Invalid ID"
                  exit 1
              fi
              sed -i "$id d" $cron_job_file
              echo "Cron job ID $id deleted."
          else
              echo "No cron job found"
          fi
          ;;
      "deleteall")
          rm -f $cron_job_file
         echo "All cron jobs deleted"
         ;;
      *)
         cron_help
         exit 1
         ;;
  esac
}

function cron_help {
  echo
  echo "Usage: $(basename "$0") cron <add|list|delete|deleteall>"
  echo
  echo "Adds, lists, or deletes cron jobs"
  echo 
  echo "Options:"
  echo "  add <hourly|daily|weekly|monthly|yearly> <command>, add a cron job"
  echo "  list, list all cron jobs." 
  echo "  delete <ID>, delete a cron job" 
  echo "  deleteall, delete all cron jobs" 
  echo
  echo "Example:"
  echo "  # $(basename "$0") cron add yearly \"/bin/df -h >> /var/log/disk.log\""
  echo "  added '30 0 1 1 * root /bin/df -h >> /var/log/disk.log'"

  echo 
  echo "  # $(basename "$0") cron list"
  echo "  ID --- CRON JOB"
  echo "  1 - 30 0 1 1 * root /bin/df -h >> /var/log/disk.log"
  echo
  echo "  # $(basename "$0") cron delete 1"
  echo "  Cron job ID 1 deleted."
  echo
  echo "  # $(basename "$0") cron deleteall"
  echo "  All cron jobs deleted"
  echo 
}
