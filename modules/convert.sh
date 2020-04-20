function convert {
  checkargn $# 2
  inputFile=$1 
  outputFile=$2  
  if [[ "$inputFile" != "" ]] && [[ "$outputFile" != "" ]]; then
    inputFileType=${inputFile##*.}
    outputFileType=${outputFile##*.}
    types=('mp4' 'avi' 'flv' 'wmv' 'mkv')
    for i in "${types[@]}"; do
      if [ "$inputFileType" == $i ]; then
        video
      fi	
      done
  elif [ $inputFile == "" ]; then
    echo "Error: no input file"
  else 
    echo "Error: atleast one output file format needed"
  fi
}  

function video {	
  ffmpeg -i $inputFile $outputFile -hide_banner
  status=$?https://github.com/treehouses/cli
  if [ "$status" == 0 ]; then
    echo "$inputFile has been successfully converted to $outputFile"
  else
    echo "Error:convertion unsuccessful"
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

