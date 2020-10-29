function memory_total() {
  option=$1
  case $option in
    'gb')
      t_M=$(free -m | grep -i Mem | awk '{printf $2}')
      t=$(echo "scale=2;$t_M/1024" | bc)
      ;;
    'mb')
      t=$(free -m | grep -i Mem | awk '{printf $2}')
      ;;
    '')
      t=$(free | grep -i Mem | awk '{printf $2}')
      ;;
    *)
      log_and_exit1 "error: only 'gb' and 'mb' argument accepted (check 'treehouses help memory')"
      ;;
  esac
}

function memory_used {
  option=$1
  case $option in
    'gb')
      u_M=$(free -m | grep -i Mem | awk '{printf $3}')
      u=$(echo "scale=2;$u_M/1024" | bc)
      bc_M=$(free -m | grep -i Mem | awk '{printf $6}')
      bc=$(echo "scale=2;$bc_M/1024" | bc)
      ubc=$(echo $u+$bc|bc)
      ;;
    'mb')
      u=$(free -m | grep -i Mem | awk '{printf $3}')
      bc=$(free -m | grep -i Mem | awk '{printf $6}')
      ubc=$((u+bc))
      ;;

    '')
      u=$(free | grep -i Mem | awk '{printf $3}')
      bc=$(free | grep -i Mem | awk '{printf $6}')
      ubc=$((u+bc))
      ;;
     *)
      log_and_exit1 "error: only 'gb' and 'mb' argument accepted (check 'treehouses help memory')"
      ;;
  esac
}

function memory_free {
  option=$1
  case $option in
    'gb')
      f_G=$(free -m | grep -i Mem | awk '{printf $4}')
      f=$(echo "scale=2;$f_G/1024" | bc)
      ;;
    'mb')
      f=$(free -m | grep -i Mem | awk '{printf $4}')
      ;;
    '')
      f=$(free | grep -i Mem | awk '{printf $4}')
      ;;
    *)
      log_and_exit1 "error: only 'gb' and 'mb' argument accepted (check 'treehouses help memory')"
      ;;
  esac
}

function memory() {
  checkargn $# 2
  check_missing_packages "bc"

  COMP="rpi"
  if [ "$(detectrpi)" = "nonrpi" ];
  then
    COMP="system"
  fi

  if [ "$1" == "total" ] ; then
    memory_total $2
    echo "$t";
    exit 0
  fi

  if [ "$1" == "used" ] ; then
    memory_used $2
    echo "$ubc";
    exit 0
  fi

  if [ "$1" == "free" ] ; then
    memory_free $2
    echo "$f";
    exit 0
  fi

  option=$1
  case $option in
    'gb')
      memory_total 'gb'
      memory_used 'gb'
      memory_free 'gb'
      echo "Your $COMP has $t gigabytes of total memory with $ubc gigabytes used and $f gigabytes available"
      ;;
    'mb')
      memory_total 'mb'
      memory_used 'mb'
      memory_free 'mb'
      echo "Your $COMP has $t megabytes of total memory with $ubc megabytes used and $f megabytes available"
      ;;
    '')
      memory_total "$option"
      memory_used "$option"
      memory_free "$option"
      echo "Your $COMP has $t bytes of total memory with $ubc bytes used and $f bytes available"
      ;;
    *)
      log_and_exit1 "error: only 'gb' and 'mb' argument accepted (check 'treehouses help memory )"
  esac
}

function memory_help {
  echo
  echo "Usage: $BASENAME memory [total|used|free] [gb|mb]"
  echo
  echo "Displays the various values for total, used, and free RAM memory."
  echo
  echo "Example:"
  echo "  $BASENAME memory"
  echo "      This will display in a single sentence 3 different RAM memory values in bytes for total, used and free memory."
  echo
  echo "  $BASENAME memory gb"
  echo "      This will display in a single sentence 3 different RAM memory values in gigabytes for total, used and free memory."
  echo
  echo "  $BASENAME memory total"
  echo "      This will return the numerical value for the total memory (value in bytes)."
  echo
  echo "  $BASENAME memory used"
  echo "      This will return the numerical value for the used memory (value in bytes)."
  echo
  echo "  $BASENAME memory free mb"
  echo "      This will return the numerical value for the remaining free memory (value in megabytes)."
  echo
}
