function storage_total() {
  option=$1
  case $option in
    'gb')
      t_M=$(df -BG | grep '/dev/root' | awk '{print $2}')
      t=$(echo "scale=2;$t_M/(1024*(10^-2))" | bc)
      ;;
    'mb')
      t=$(df -BM | grep '/dev/root' | awk '{print $2}')
      ;;
    'kb')
      t=$(df -BK | grep '/dev/root' | awk '{print $2}')
      ;;
    '')
      t_M=$(df -BG | grep '/dev/root' | awk '{print $2}')
      t=$(echo "scale=2;$t_M/(1024*(10^-2))" | bc)
      ;;
    *)
      log_and_exit1 "error: only 'gb', 'mb' and 'kb' argument accepted (check 'treehouses help storage')"
      ;;
  esac
}

function storage_used {
  option=$1
  case $option in
    'gb')
      u_M=$(df -BG | grep '/dev/root' | awk '{print $3}')
      u=$(echo "scale=2;$u_M/(1024*(10^-2))" | bc)
      ;;
    'mb')
      u=$(df -BM | grep '/dev/root' | awk '{print $3}')
      ;;
    'kb')
      u=$(df -BK | grep '/dev/root' | awk '{print $3}')
      ;;
    '')
      u_M=$(df -BG | grep '/dev/root' | awk '{print $3}')
      u=$(echo "scale=2;$u_M/(1024*(10^-2))" | bc)
      ;;
     *)
      log_and_exit1 "error: only 'gb', 'mb' and 'kb' argument accepted (check 'treehouses help storage')"
      ;;
  esac
}

function storage_free {
  option=$1
  case $option in
    'gb')
      f_G=$(df -BG | grep '/dev/root' | awk '{print $4}')
      f=$(echo "scale=2;$f_G/(1024*(10^-2))" | bc)
      ;;
    'mb')
      f=$(df -BM | grep '/dev/root' | awk '{print $4}')
      ;;
    'kb')
      f=$(df -BK | grep '/dev/root' | awk '{print $4}')
      ;;
    '')
      f_G=$(df -BG | grep '/dev/root' | awk '{print $4}')
      f=$(echo "scale=2;$f_G/(1024*(10^-2))" | bc)
      ;;
    *)
      log_and_exit1 "error: only 'gb', 'mb' and 'kb' argument accepted (check 'treehouses help storage')"
      ;;
  esac
}

function storage() {
  checkargn $# 2
  check_missing_packages "bc"

  COMP="rpi"
  if [ "$(detectrpi)" = "nonrpi" ];
  then
    COMP="system"
  fi

  if [ "$1" == "total" ] ; then
    storage_total $2
    echo "$t";
    exit 0
  fi

  if [ "$1" == "used" ] ; then
    storage_used $2
    echo "$u";
    exit 0
  fi

  if [ "$1" == "free" ] ; then
    storage_free $2
    echo "$f";
    exit 0
  fi

  option=$1
  case $option in
    'gb')
      storage_total 'gb'
      storage_used 'gb'
      storage_free 'gb'
      echo "Your $COMP has $t gigabytes of total storage with $u gigabytes used and $f gigabytes available"
      ;;
    'mb')
      storage_total 'mb'
      storage_used 'mb'
      storage_free 'mb'
      echo "Your $COMP has $t (megabytes) of total storage with $u (megabytes) used and $f (megabytes) available"
      ;;
    'kb')
      storage_total 'kb'
      storage_used 'kb'
      storage_free 'kb'
      echo "Your $COMP has $t (kilobytes) of total storage with $u (kilobytes) used and $f (kilobytes) available"
      ;;
    '')
      storage_total "$option"
      storage_used "$option"
      storage_free "$option"
      echo "Your $COMP has $t gigabytes of total storage with $u gigabytes used and $f gigabytes available"
      ;;
    *)
      log_and_exit1 "error: only 'gb', 'mb' and 'kb' argument accepted (check 'treehouses help storage')"
      ;;
  esac
}

function storage_help {
  echo
  echo "Usage: $BASENAME storage [total|used|free] [gb|mb|kb]"
  echo
  echo "Displays the various values for total, used, and free storage."
  echo
  echo "Example:"
  echo "  $BASENAME storage"
  echo "      This will display in a single sentence 3 different storage values for total, used and free storage in gigabytes."
  echo
  echo "  $BASENAME storage gb"
  echo "      This will display in a single sentence 3 different storage values in gigabytes for total, used and free storage."
  echo
  echo "  $BASENAME storage total"
  echo "      This will return the numerical value for the total storage (value in kilobytes)."
  echo
  echo "  $BASENAME storage used"
  echo "      This will return the numerical value for the used storage (value in kilobytes)."
  echo
  echo "  $BASENAME storage free mb"
  echo "      This will return the numerical value for the remaining free storage (value in megabytes)."
  echo
  echo "  $BASENAME storage used kb"
  echo "      This will return the numerical value for the used storage (value in kilobytes)."
  echo
}