function picture {
  # check if tiv binary exists
  check_missing_binary tiv "tiv is very awesome\nprogrammed to display images in terminal\ninstall instructions are found in https://github.com/stefanhaustein/TerminalImageViewer"

  # check if imagemagick pkg is installed
  check_missing_packages imagemagick

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
