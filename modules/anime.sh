function anime {
  checkargn $# 0
  checkinternet
  local query time1 result cnt
  query=$(cat <<EOF
query(\$timestamp: Int) {
  Page(perPage: 25) {
    airingSchedules(sort: TIME_DESC, airingAt_lesser: \$timestamp) {
      media {
        title {
          romaji
          native
        }
        description
        genres
      }
    }
  }
}
EOF
)
  query="$(echo $query)"
  time1=$(date --date="$(date --iso-8601=s -d @1525192000) -30 days" +%s)
  result=$(curl -s -H 'Content-Type: application/json' -X POST -d "{ \"query\": \"$query\", \"variables\": { \"timestamp\":$time1 }}" https://graphql.anilist.co )
  titles=$(echo "$result" | jq '.data.Page.airingSchedules[][].title.romaji')
  descripts=$(echo "$result" | jq '.data.Page.airingSchedules[][].description' | sed -e 's/<[^>]*>//g')
  cnt=1
  echo
  while IFS= read -r line; do
    echo -n "Title: "
    echo -e "$titles" | sed "${cnt}q;d" | sed 's/"//g'
    echo -n "Descr: "
    echo -e "$line" | sed 's/"//g' | sed '/^(Source/d' | sed 's/\\//g' | fmt -t
    ((cnt=cnt+1))
  done <<< "$descripts"
}

function anime_help {
  echo
  echo "Usage: $BASENAME anime"
  echo
  echo "Example:"
  echo "  $BASENAME anime"
  echo "      Shows the latest 25 animes, and descriptions from the last month"
  echo
}
