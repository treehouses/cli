function convert {
  local frames percent status
  checkargn $# 2
  inputFile=$1
  outputFile=$2
  if [ -e "$inputFile" ] && [[ "$outputFile" != "" ]]; then
    frames=$(ffprobe -v error -select_streams v:0 \
      -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $inputFile)
    while read -r line || { status=$line && break; }; do
      percent=$(bc <<<"scale=2; ($line / $frames) * 100")
      echo -ne "  [$percent%] completed"\\r
    done < <(ffmpeg -y -i $inputFile $outputFile -loglevel quiet \
               -hide_banner -max_error_rate 0.0 -progress - -nostats \
               | grep -oP --line-buffered '(?<=frame=)[0-9]+'; printf $?)
    if [ "$status" == 0 ]; then
      echo "$inputFile has been successfully converted to $outputFile"
    else
      echo "conversion unsuccessful"
    fi
  else
    echo "Error: invalid arguments"
  fi
}

function convert_help {
  echo
  echo "Usage: $BASENAME convert"
  echo
  echo "Example:"
  echo "  $BASENAME convert <input file format> <output file format>"
  echo "      convert the input file format to output video format "
}

