function sdbench {
  DATAMB=${1:-128}
  FILENM=~/test.dat
  [ -f /flash/config.txt ] && CONFIG=/flash/config.txt || CONFIG=/boot/config.txt
  trap 'rm -f "${FILENM}"' EXIT
  WRCMD="rm -f ${FILENM} && sync && dd if=/dev/zero of=${FILENM} bs=1M count=${DATAMB} conv=fsync 2>&1 | grep -v records | sed 's/.*, //'"
  RDCMD="echo 3 > /proc/sys/vm/drop_caches && sync && dd if=${FILENM} of=/dev/null bs=1M 2>&1 | grep -v records | sed 's/.*, //'"
  WRRESULT="$(eval ${WRCMD})"
  RDRESULT="$(eval ${RDCMD})"
  echo "READ & WRITE - ${RDRESULT} & ${WRRESULT}"
}

function sdbench_help {
  echo
  echo "Usage: $BASENAME sdbench"
  echo
  echo "Example:"
  echo "  $BASENAME sdbench"
  echo "    prints the read and write speed"
}
