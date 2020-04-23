function aphidden {
  hide="hidden "
  apmain "$@"
}


function aphidden_help () {
  echo
  echo "Usage: $BASENAME aphidden <local|internet> <ESSID> [password]"
  echo
  echo "When the Raspberry pi is connected to a network via an ethernet cable this command"
  echo "creates a wireless access point that users can connect to via wifi. If the mode is"
  echo "'internet' the ethernet connection will be shared in the access point."
  echo
  echo "Examples:"
  echo "  $BASENAME aphidden local apname apPassword"
  echo "      Creates a hidden ap with ESSID 'apname' and password 'apPassword'."
  echo "      This hotspot will not share the ethernet connection if present."
  echo
  echo "  $BASENAME aphidden local apname"
  echo "      Creates an open hidden ap with ESSID 'apname'."
  echo "      This hotspot will not share ethernet connection when present."
  echo
  echo "  $BASENAME aphidden internet apname apPassword"
  echo "      Creates a hidden ap with ESSID 'apname' and password 'apPassword'."
  echo "      This hotspot will share the ethernet connection when present."
  echo
  echo "  $BASENAME aphidden internet apname"
  echo "      Creates an open hidden ap with ESSID 'apname'."
  echo "      This hotspot will share the ethernet connection when present."
  echo
  echo "  This command can be used with the argument '--ip=x.y.z.w' to specify the base ip (x.y.z) for the clients/ap."
  echo
  echo "  $BASENAME aphidden internet apname --ip=192.168.2.24"
  echo "      All the clients of this network will have an ip under the network 192.168.2.0"
  echo
}
