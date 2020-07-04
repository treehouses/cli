function magazines() {
  checkargn $# 3
  magtype="$1"
  req="$2"
  lang="$3"
  available_mag=0
  if [ -z "$magtype" ]; then
    echo "ERROR: no magazine type given"
    exit 1
  fi
  for file in $MAGAZINES/*; do
      if [ "$magtype" = "$(echo "${file##*/}" | sed -e 's/^download-//' -e 's/.sh$//')" ]; then available_mag=1; fi
  done
  if [ $available_mag = 0 ]; then
    echo "Please specify a valid magazine type, these include: magpi, hackspace, wireframe, helloworld"
  elif [ "$req" = "" ]; then source $MAGAZINES/download-$magtype.sh && info
  elif [ "$req" = "latest" ] || [ "$req" = "all" ] || [[ "$req" =~ ^[0-9]+$ ]] || [[ "$req" = "language" ]]; then
    if [[ "$req" = "language" ]]; then
      echo "coming soon!"
      exit 1
    fi
    checkinternet
    if [ ! -d "$magtype" ]; then mkdir $magtype; fi
    cd $magtype || return
    if [[ "$req" =~ ^[0-9]+$ ]]; then source $MAGAZINES/download-$magtype.sh && number
    else source $MAGAZINES/download-$magtype.sh && $req; fi
    cd ..
    echo "Requested issue(s) saved in the $magtype directory"
  else
    magazine_help
  fi
}

function magazine_help {
  echo
  echo "Usage: $BASENAME magazines <helloworld|hackspace|magpi|wireframe> [all|latest|number]"
  echo
  echo "This downloads the specified issue of a magazine as a pdf with filename <mag_type>#.pdf based on user input"
  echo
  echo "Example:"
  echo
  echo "  $BASENAME magazines magpi"
  echo "      This will print out details about the magpi magazine."
  echo
  echo "  $BASENAME magazines magpi all"
  echo "      This will download all the currently present issues of magpi."
  echo
  echo "  $BASENAME magazines magpi latest"
  echo "      This will download the latest issue of magpi."
  echo
  echo "  $BASENAME magazines magpi number"
  echo "      This will download issue [number] of magpi."
  echo
  echo "  $BASENAME magazines magpi language [language_choice] ((coming soon))"
  echo "      This will download all available [language_choice] issues of magpi."
  echo
  echo "  $BASENAME magazines helloworld"
  echo "      This will print out details about the helloworld magazine."
  echo
  echo "  $BASENAME magazines helloworld all"
  echo "      This will download all the currently present issues of helloworld."
  echo
  echo "  $BASENAME magazines helloworld latest"
  echo "      This will download the latest issue of helloworld."
  echo
  echo "  $BASENAME magazines helloworld number"
  echo "      This will download issue [number] of helloworld."
  echo
  echo "  $BASENAME magazines hackspace"
  echo "      This will print out details about the hackspace magazine."
  echo
  echo "  $BASENAME magazines hackspace all"
  echo "      This will download all the currently present issues of hackspace."
  echo
  echo "  $BASENAME magazines hackspace latest"
  echo "      This will download the latest issue of hackspace."
  echo
  echo "  $BASENAME magazines hackspace number"
  echo "      This will download issue [number] of hackspace."
  echo
  echo "  $BASENAME magazines wireframe"
  echo "      This will print out details about the wireframe magazine."
  echo
  echo "  $BASENAME magazines wireframe all"
  echo "      This will download all the currently present issues of wireframe."
  echo
  echo "  $BASENAME magazines wireframe latest"
  echo "      This will download the latest issue of wireframe."
  echo
  echo "  $BASENAME magazines wireframe number"
  echo "      This will download issue [number] of wireframe."
  echo
}
