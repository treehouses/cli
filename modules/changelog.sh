function changelog {
local LOGPATH displaymode version1 version2 CURRENT
CURRENT=$(treehouses version)
LOGPATH="$SCRIPTFOLDER/CHANGELOG.md"
checkargn $# 3
displaymode="$1"
version1="$2"
version2="$3"

if [ ! -f "$LOGPATH" ]; then
  echo "File does not exist!"
  exit 1
fi

case "$displaymode" in
  view)
      checkargn $# 1
      view $LOGPATH
      ;;
  "")
      checkargn $# 0
      cat $LOGPATH
     ;;
  compare)
      case "$version1" in
      "")
        echo "Error: only 'compare [previous version]' and 'compare [previous version] [later version] are supported."
        exit 1
        ;;
      *)
        case "$version2" in
         "")
          checkargn $# 2
          sed "/^### $CURRENT/!d;s//&\n/;s/.*\n//;:a;/^### $version1/bb;\$!{n;ba};:b;s//\n&/;P;D" $LOGPATH #grabs text between version numbers, print bottom to top
          ;;
        *)
          checkargn $# 3
          sed "/^### $version2/!d;s//&\n/;s/.*\n//;:a;/^### $version1/bb;\$!{n;ba};:b;s//\n&/;P;D" $LOGPATH
          ;;
        esac
        ;;
      esac
      ;;
  *)
      echo "Error: only 'view', 'compare' and blank options are supported. "
      exit 1
      ;;
  esac
}

function changelog_help {
  CYAN='\033[1;36m'
  NC='\033[0m' #no color
  echo
  echo "Usage: $BASENAME changelog"
  echo "  Views the treehouses changelog generated by auto-changelog."
  echo
  echo "Usage: $BASENAME changelog view"
  echo "  Opens the raw changelog in vim read only mode."
  echo
  echo "Usage: $BASENAME changelog compare [previous version]"
  echo "  Displays all changes since a previous version to the current version."
  echo
  echo "Usage: $BASENAME changelog compare [previous version] [later version]"
  echo "  Displays all changes since a previous version to the version specified."
  echo
  echo "Example: $BASENAME changelog"
  echo
  echo -e "${CYAN}- \`treehouses services privatebin icon refactor\` [\`#1254\`](https://github.com/treehouses/cli/pull/1254)"
  echo
  echo "> 12 May 2020"
  echo
  echo "#### [1.20.22](https://github.com/treehouses/cli/compare/1.20.21...1.20.22)"
  echo
  echo -e "### Changelog${NC}"
}
