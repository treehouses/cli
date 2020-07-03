function magazine() {
  checkargn $# 3
  magtype="$1"
  req="$2"
  lang="$3"
  available_mag=0
  if [ -z "$magtype" ]; then
    echo "ERROR: no magazine type given"
    exit 1
  fi
  for file in $MAGAZINE/*; do
      if [ "$magtype" = "$(echo "${file##*/}" | sed -e 's/^download-//' -e 's/.sh$//')" ]; then available_mag=1; fi
  done
  if [ $available_mag = 0 ]; then
    echo "Please specify a valid magazine type, these include: magpi, hackspace, wireframe, helloworld"
  elif [ "$req" = "" ]; then source $MAGAZINE/download-$magtype.sh && info
  elif [ "$req" = "latest" ] || [ "$req" = "all" ] || [[ "$req" =~ ^[0-9]+$ ]] || [[ "$req" = "language" ]]; then
    if [[ "$req" = "language" ]]; then
      echo "coming soon!"
      exit 1
    fi
    checkinternet
    if [ ! -d "$magtype" ]; then mkdir $magtype; fi
    cd $magtype || return
    if [[ "$req" =~ ^[0-9]+$ ]]; then source $MAGAZINE/download-$magtype.sh && number
    else source $MAGAZINE/download-$magtype.sh && $req; fi
    cd ..
    echo "Requested issue(s) saved in the $magtype directory if there are no errors"
  else
    magazine_help
  fi
}

function magazine_help {
  echo
  echo "Usage: $BASENAME magazine <helloworld|hackspace|magpi|wireframe> [all|latest|number]"
  echo
  echo "This downloads the specified issue of a magazine as a pdf with filename <mag_type>#.pdf based on user input"
  echo "The MagPi magazine also supports other languages listed above to a limited number of issues"
  echo
  echo "Example:"
  echo
  echo "  $BASENAME magazine magpi"
  echo "      This will print out details about the magpi magazine."
  echo
  echo "  $BASENAME magazine magpi all"
  echo "      This will download all the currently present issues of magpi."
  echo
  echo "  $BASENAME magazine magpi latest"
  echo "      This will download the latest issue of magpi."
  echo
  echo "  $BASENAME magazine magpi number"
  echo "      This will download issue [number] of magpi."
  echo
  echo "  $BASENAME magazine magpi language [language_choice] ((coming soon))"
  echo "      This will download all available [language_choice] issues of magpi."
  echo
}
