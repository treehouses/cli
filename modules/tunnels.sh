function tunnels {
  checkroot
  case "$1" in
    pagekite-install)
      checkargn $# 3
      email="$2"
      sitename="$3"
      FILE=~/.pagekite.rc
      check_missing_packages pagekite
      if [ -f "$FILE" ]; then
	rm $FILE
      fi
      screen -dmS pagekite bash -c "printf \"Y \n $email \n $sitename \n Y \n Y \n\" | /usr/local/bin/pagekite.py --signup"
      echo "Your kite is ready to fly!"
      echo
      echo "Note: To complete the signup process, check your e-mail (and spam folders) for activation instructions."
      echo "You can give PageKite a try first, but un-activated accounts are disabled after 15 minutes."
      echo
      echo "~<> Flying localhost:80 as https://$sitename.pagekite.me/"
      ;;
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
      echo "Error: unknown command"
      exit 1
      ;;
  esac
}

function tunnels_help {
  echo
  echo "  Usage: $BASENAME tunnels [pagekite|info]"
  echo "         $BASENAME tunnels [pagekite-install] <email> <sitename>"
  echo
  echo "  Services to host a local port on a remote url"
  echo
  echo "  Examples:"
  echo
  echo "    $BASENAME tunnels pagekite-install pagekite.0@ole.org treehouses"
  echo "        Your kite is ready to fly!"
  echo
  echo "        Note: To complete the signup process, check your e-mail (and spam folders) for activation instructions."
  echo "        You can give PageKite a try first, but un-activated accounts are disabled after 15 minutes."
  echo
  echo "        ~<> Flying localhost:80 as https://treehouses.pagekite.me/"
  echo
  echo "    $BASENAME tunnels pagekite 3000 treehouses.pagekite.me"
  echo "        Flying localhost:3000"
  echo
  echo "    $BASENAME tunnels pagekite"
  echo "        Kites are flying and all is well."
  echo
  echo "    $BASENAME tunnels pagekite --ports=3000,8000 treehouses.pagekite.me"
  echo "        Hello! This is pagekite v0.5.9.3."
  echo
  echo "    $BASENAME tunnels info"
  echo "        https://github.com/pagekite/PyPagekite"
  echo
  
}
