function inspire() {
  checkrpi
  checkargn $# 1
  checkinternet
  case "$1" in
    "")
      curl -s 'https://api.quotable.io/random' | python3 -c "import sys, json; print(json.load(sys.stdin)['content'])"
    ;;
    "fact")
       curl -s 'https://uselessfacts.jsph.pl/random.json?language=en' | python3 -c "import sys, json; print(json.load(sys.stdin)['text'])"
    ;;
    "joke")
      curl -s 'http://api.icndb.com/jokes/random' | python3 -c "import sys, json; print(json.load(sys.stdin)['value']['joke'])" | sed 's/&quot;/\"/g'
    ;;
    "qotd")
      curl -s 'http://quotes.rest/qod.json?category=inspire' | python3 -c "import sys, json; print(json.load(sys.stdin)['contents']['quotes'][0]['quote'])"
    ;;
    "random")
      curl -s 'https://api.quotable.io/random' | python3 -c "import sys, json; print(json.load(sys.stdin)['content'])"
    ;;
  esac
}

function inspire_help {
  echo
  echo "  Usage: $BASENAME inspire [joke|qotd|random]"
  echo
  echo "  Prints out inspirational quote based on input."
  echo
  echo "  Example:"
  echo "    $BASENAME inspire"
  echo "    By believing passionately in something that does not yet exist, we create it."
  echo 
  echo "    $BASENAME inspire fact"
  echo "    Leonardo Da Vinci invented the scissors."
  echo
  echo "    $BASENAME inspire qotd"
  echo "    If opportunity doesn’t knock, build a door."
  echo
  echo "    $BASENAME inspire joke"
  echo "    Chuck Norris once round-house kicked a salesman. Over the phone."
  echo
  echo "    $BASENAME inspire random"
  echo "    Quick decisions are unsafe decisions."
  echo
}
