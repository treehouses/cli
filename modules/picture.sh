function picture {
  check_missing_packages "imagemagick" "tiv"
  case "$1" in
    "")
      picture_help
    ;;
    
    *)
      tiv "$1"
    ;;
  esac
}

function picture_help {
  echo
  echo "Usage: $BASENAME picture [file|url]"
  echo
  echo "Views a picture in the terminal."
  echo
  echo "Example:"
  echo "  $BASENAME picture image.png"
  echo "  <image will be displayed in terminal>"
  echo
}