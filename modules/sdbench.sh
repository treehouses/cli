function sdbench {
  DATAMB=${1:-128}
  FILENM=~/test.dat
  [ -f /flash/config.txt ] && CONFIG=/flash/config.txt || CONFIG=/boot/config.txt

  trap 'rm -f "${FILENM}"' EXIT

  [ "$(whoami)" == "root" ] || { echo "Must be run as root!"; exit 1; }

  WRCMD="rm -f ${FILENM} && sync && dd if=/dev/zero of=${FILENM} bs=1M count=${DATAMB} conv=fsync 2>&1 | grep -v records | sed 's/.*, //'"
  RDCMD="echo 3 > /proc/sys/vm/drop_caches && sync && dd if=${FILENM} of=/dev/null bs=1M 2>&1 | grep -v records | sed 's/.*, //'"
  writeResult="$(eval "${WRCMD}")" 
  readResult="$(eval "${RDCMD}")" 
  echo "WRITE - $writeResult"
  echo "READ - $readResult"
}

function sdbench_help {
  echo
  echo "Usage: $BASENAME sdbench"
  echo
  echo "Example:"
  echo " $BASENAME sdbench"
  echo "  Prints the write and read speed"
}
