function convert {
  checkargn $# 2
  inputFile=$1
  outputFile=$2
  if [[ "$inputFile" != "" ]] && [[ "$outputFile" != "" ]]; then
    inputFileType=${inputFile##*.}
    outputFileType=${outFile##*.}
    videoFileTypes=('mp4' 'avi' 'flv' 'wmv' 'mkv')
    audioFileTypes=('mp3' 'wav' 'ogg')
    for i in "${videoFileTypes[@]}"; do
      if [ "$inputFileType" == $i ]; then
        video
      fi
    done
    for i in "${audioFileTypes[@]}"; do
      if [ "$inputFileType" == $i ]; then
        audio
      fi
    done
  elif [ $inputFile == "" ]; then
    echo "Error: no input file"
  elif [ $outputFile == "" ]; then
    echo "Error :no otput file"
  else
    convert_help
}

function video {
  ffmpeg -i $inputFile $outputFile -hide_banner
  status=$?https://github.com/treehouses/cli
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



function convert_help {
  echo
  echo "Usage: $BASENAME convert"
  echo
  echo "Example:"
  echo "  $BASENAME convert <video file input> <video file output>"
  echo "      convert the input video file format to output video file format "
}

