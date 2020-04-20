function convert {
  checkargn $# 2
  input=$1 
  output=$2  
  if [[ "$input" != "" ]] && [[ "$output" != "" ]]; then
    inputFileType=`echo "$input" | sed 's/.*\.//'`
    outputFileType=`echo "$output" | sed 's/.*\.//'`
    types=('mp4' 'avi' 'flv' 'wmv' 'mkv')
    for i in "${types[@]}"; do
      if [ "$inputFileType" == $i ]; then
        video
      fi	
      done
  elif [ $input == "" ]; then
    echo "Error: no input file"
  else 
    echo "Error: atleast one output file format needed"
  fi
}  

function video {	
  ffmpeg -i $input $output -hide_banner
  status=$?
  if [ "$status" == 0 ]; then
    echo "$input has been successfully converted to $output"
  else
    echo "Error:convertion unsuccessful"
  fi  
}

function convert_help {
  echo
  echo "Usage: $BASENAME convert"
  echo
  echo "Example:"
  echo "  $BASENAME convert <input file> <output file>"
  echo "    convert the input video file format to output video file format "
}

