function convert {
  checkargn $# 2
  inputFile=$1
  outputFile=$2
  if [[ "$inputFile" != "" ]] && [[ "$outputFile" != "" ]]; then
    ffmpeg -i $inputFile $outputFile -hide_banner
    status=$?
    if [ "$status" == 0 ]; then
      echo "$inputFile has been successfully converted to $outputFile"
    else
      echo "conversion unsuccessful"
    fi
  elif [ $inputFile == "" ]; then
    echo "Error: no input file"
  elif [ $outputFile == "" ]; then
    echo "Error: no output file"
  else
    convert_help
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

