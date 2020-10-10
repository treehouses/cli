function apply_blocker {
  local file_nh folder_nh hostn
  if [ ! -f $TEMPLATES/blocker/1_hosts ]; then
    ($TEMPLATES/blocker/blocker.sh)
  fi
  folder_nh="$TEMPLATES/blocker"
  case "$BLOCKER" in
    "1")
      file_nh=$(<$folder_nh/1_hosts)
      ;;
    "2")
      file_nh=$(<$folder_nh/2_hosts)
      ;;
    "3")
      file_nh=$(<$folder_nh/3_hosts)
      ;;
    "4")
      file_nh=$(<$folder_nh/4_hosts)
      ;;
    "max")
      file_nh=$(<$folder_nh/5_hosts)
      ;;
  esac
  hostn=$(hostname)
  cp "$TEMPLATES/hosts" "$TEMPLATES/hosts1"
  sed -i "s/HOSTNAME/$hostn/g" "$TEMPLATES/hosts1"
  sync;sync;sync;
  cp "$TEMPLATES/hosts1" /etc/hosts
  rm -f "$TEMPLATES/hosts1"
  if [ ! $BLOCKER = "0" ]; then
    echo "$file_nh" >> /etc/hosts
  fi
  sync;sync;sync;
  logit "$1"
}

function blocker {
  checkroot
  checkargn $# 1
  case "$1" in
    "")
	  case "$BLOCKER" in
	    "0")
		  logit "blocker 0: blocker is disabled"
		  ;;
	    "1")
		  logit "blocker 1: level is set to ads (adware + malware)"
		  ;;
	    "2")
		  logit "blocker 2: level is set to ads + porn"
		  ;;
	    "3")
		  logit "blocker 3: level is set to ads + gambling + porn"
		  ;;
	    "4")
		  logit "blocker 4: level is set to ads + fakenews + gambling + porn"
		  ;;
		"max")
		  logit "blocker X: level is set to ads + fakenews + gambling + porn + social"
		  ;;
	  esac
      exit 0;
      ;;
	"0")
      BLOCKER=0
      apply_blocker "blocker 0: blocker disabled"
      ;;
    "1")
      BLOCKER=1
      apply_blocker "blocker 1: level set to ads (adware + malware)"
      ;;
    "2")
      BLOCKER=2
      apply_blocker "blocker 2: level set to ads + porn"
      ;;
    "3")
      BLOCKER=3
      apply_blocker "blocker 3: level set to ads + gambling + porn"
      ;;
    "4")
      BLOCKER=4
      apply_blocker "blocker 4: level set to ads + fakenews + gambling + porn"
      ;;
	"max")
	  BLOCKER=max
      apply_blocker "blocker X: level set to ads + fakenews + gambling + porn + social"
	  ;;
    *)
      log_and_exit1 "Error: only '0' '1' '2' '3' '4' 'max' options are supported"
      ;;
  esac
  conf_var_update "BLOCKER" "$BLOCKER"
}

function blocker_help {
  echo
  echo "Usage: $BASENAME blocker <0|1|2|3|4|max>"
  echo
  echo "Example:"
  echo "  $BASENAME blocker"
  echo "      blocker 0: blocker is disabled"
  echo
  echo "  $BASENAME blocker 0"
  echo "      blocker 0: blocker disabled"
  echo
  echo "  $BASENAME blocker 1"
  echo "      blocker 1: level set to ads (adware + malware)"
  echo
  echo "  $BASENAME blocker 2"
  echo "      blocker 2: level set to ads + porn"
  echo
  echo "  $BASENAME blocker 3"
  echo "      blocker 3: level set to ads + gambling + porn"
  echo
  echo "  $BASENAME blocker 4"
  echo "      blocker 4: level set to ads + fakenews + gambling + porn"
  echo
  echo "  $BASENAME blocker max"
  echo "      blocker X: level set to ads + fakenews + gambling + porn + social"
  echo
}
