function sdbench {
  local datamb filenm wrcmd rdcmd wrresult rdresult config
  checkroot
  checkargn $# 0
  datamb=${1:-128}
  filenm=~/test.dat
  trap 'rm -f "${filenm}"' EXIT
  wrcmd="rm -f ${filenm} && sync && dd if=/dev/zero of=${filenm} bs=1M count=${datamb} conv=fsync 2>&1 | grep -v records | sed 's/.*, //'"
  rdcmd="echo 3 > /proc/sys/vm/drop_caches && sync && dd if=${filenm} of=/dev/null bs=1M 2>&1 | grep -v records | sed 's/.*, //'"
  wrresult="$(eval ${wrcmd})"
  rdresult="$(eval ${rdcmd})"
  echo "read  - ${rdresult}"
  echo "write - ${wrresult}"
}

function sdbench_help {
  echo
  echo "Usage: $BASENAME sdbench"
  echo
  echo "Example:"
  echo "  $BASENAME sdbench"
  echo "    prints the read and write speed"
}
