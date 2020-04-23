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
      echo "convertion unsuccessful"
    fi
  elif [ $inputFile == "" ]; then
    echo "Error: no input file"
  elif [ $outputFile == "" ]; then
<<<<<<< HEAD
    echo "Error: no output file"
=======
    echo "Error :no output file"
>>>>>>> ff287d23978b1fd688118878a0727582824103a5
  else
    convert_help
  fi
}

<<<<<<< HEAD
=======
function video {
  ffmpeg -i $inputFile $outputFile -hide_banner
  status=$?
  if [ "$status" == 0 ]; then
    echo "$inputFile has been successfully converted to $outputFile"
  else
    echo "convertion unsuccessful"
  fi
}

function audio {
  ffmpeg -i $inputFile $outputFile
  status=$?
  if [ "$status" == 0 ]; then
    echo "$inputFile has been successfully converted to $outputFile"
  else
    echo "convertion unsuccessful"
  fi
}



>>>>>>> ff287d23978b1fd688118878a0727582824103a5
function convert_help {
  echo
  echo "Usage: $BASENAME convert"
  echo
  echo "Example:"
  echo "  $BASENAME convert <input file format> <output file format>"
  echo "      convert the input file format to output video format "
}

