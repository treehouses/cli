function convert {
  local frames percent status
  checkargn $# 2
  inputFile="$1"
  outputFile="$2"
  if [ -e "$inputFile" ] && [[ "$outputFile" != "" ]]; then
    frames=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $inputFile)
    if ! [[ $frames =~ ^[0-9]+$ ]]; then
      frames=""
    fi
    while read -r line || { status=$line && break; }; do
      if [ -z $frames ]; then
        echo -ne "conversion running"\\r
      else
        percent=$(bc <<< "scale=2; ($line / $frames) * 100")
        echo -ne "  [$percent%] completed"\\r
      fi
    done < <(ffmpeg -y -i $inputFile $outputFile -loglevel error -hide_banner -max_error_rate 0.0 -progress - -nostats | grep -oP --line-buffered '(?<=frame=)[0-9]+'; printf "${PIPESTATUS[0]}")
    # be careful not to delete line-buffered
    if [ "$status" = 0 ]; then
      echo "$inputFile has been successfully converted to $outputFile"
    else
      echo "conversion unsuccessful"
    fi
  else
    log_and_exit1 "Error: invalid arguments"
  fi
}

function convert_help {
  echo
  echo "Usage: $BASENAME convert <input file> <output file>"
  echo
  echo "Example:"
  echo "  $BASENAME convert video.mp4 video.mp3"
  echo "      convert video mp4 file to mp3 format"
}

