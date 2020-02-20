function tunnels {
  case "$1" in
    pagekite)
      check_missing_packages pagekite
      shift
      pagekite "$@"
      ;;
    info)
      echo "https://github.com/pagekite/PyPagekite"
      echo
      echo "PageKite is a reverse proxy tool that connects local servers to the public Internet."
      echo "It gives proper domain names to servers running on localhost and makes them visible to the world, bypassing NAT and firewalls."
      echo "Pagekite sign up url: https://pagekite.net/signup/"
      echo "Pagekite also offers sponsored accounts to Free Software projects which fulfill certain criteria."
      echo "https://pagekite.net/support/free-for-foss"
      ;;
    *)
      log_and_exit1 "Error: unknown command"
      ;;
  esac
}

function tunnels_help {
  echo
  echo "  Usage: $BASENAME tunnels [pagekite|info]"
  echo
  echo "  Services to host a local port on a remote url"
  echo
  echo "  Examples:"
  echo
  echo "    $(basename "$0") tunnels pagekite 3000 treehouses.pagekite.me"
  echo "        Flying localhost:3000"
  echo
  echo "    $(basename "$0") tunnels pagekite"
  echo "        Kites are flying and all is well."
  echo
  echo "    $(basename "$0") tunnels pagekite --ports=3000,8000 treehouses.pagekite.me"
  echo "        Hello! This is pagekite v0.5.9.3."
  echo
  echo "    $(basename "$0") tunnels info"
  echo "        https://github.com/pagekite/PyPagekite"
  echo
  
}
