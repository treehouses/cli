function password () {
if [[ $1 == "" ]]
then
   log_and_exit1 "Error: Password not entered"
else
  chpasswd <<< "pi:$1"
  echo "Success: the password has been changed"
fi
}

function password_help () {
  echo
  echo "Usage: $BASENAME password <password>"
  echo
  echo "Changes the password for 'pi' user"
  echo
  echo "Example:"
  echo "  $BASENAME password ABC"
  echo "      Sets the password for 'pi' user to 'ABC'."
  echo
}
