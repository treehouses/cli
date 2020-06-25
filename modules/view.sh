function view {
    case "$1" in
      "")
        view_help
      ;;
    
      *)
        tiv "$1"
      ;;
    esac
}

function view_help {
  echo
  echo "Usage: $BASENAME view [file|url]"
  echo
  echo "Views a picture in the terminal."
  echo
  echo "Example:"
  echo "  $BASENAME view image.png"
  echo "  <image will be displayed in terminal>"
  echo
}