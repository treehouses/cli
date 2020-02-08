function internet {
  if wget -q --spider -T 3 --no-check-certificate https://www.google.com; then
    log_and_exit0 "true"
  fi
  logit "false"
}

function internet_help {
  echo
  echo "Usage: $BASENAME internet"
  echo
  echo "Outputs true if the rpi can reach internet, or false if it doesn't"
  echo
  echo "Example:"
  echo "  $BASENAME internet"
  echo "      the rpi has access to internet -> output: true"
  echo "      the rpi doesn't have access to internet -> output: false"
  echo
}
