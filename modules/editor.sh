function editor {
  checkroot

  if grep EDITOR /etc/bash.bashrc | grep -q export /etc/bash.bashrc; then
    EDITOR="$(grep EDITOR /etc/bash.bashrc | grep export | sed 's/export EDITOR=//g')"
  fi

  if [ -z "$EDITOR" ] && [ "$1" == "config" ]; then
    echo
    echo "Error: default editor not set."
    echo "Use \"treehouses editor default\""
    echo "or \"treehouses editor set [vim|emacs|nano]\" to set your default editor."
    echo
    exit 1
  fi 

  if [ $# -eq 0 ]; then
    if [ -z "$EDITOR" ]; then
      echo
      echo "Error: default editor not set."
      echo "Use \"treehouses editor default\""
      echo "or \"treehouses editor set [vim|emacs|nano]\" to set your default editor."
      echo
      exit 1
    fi 
    echo $EDITOR
    exit 0
  fi

  case "$1" in 
    default)
      checkargn $# 1
      if ! grep EDITOR /etc/bash.bashrc | grep -q export /etc/bash.bashrc; then
        echo "export EDITOR=vim" >> /etc/bash.bashrc
      else
        sed -i -e "s/EDITOR=.*/EDITOR=vim/g" /etc/bash.bashrc
      fi
      cp "$TEMPLATES/editor/vim/vimrc_default" /etc/vim/vimrc 
      cp "$TEMPLATES/editor/nano/nanorc_default" /etc/nanorc
      rm -rf /etc/vim/vimrc.local
      echo "Text editor is now vim, using the default config."
      exit 0
      ;;

    set)
      if [ $# -lt 2 ]; then 
        echo
        echo "Error: No editor specified."
        echo
        editor_help
        exit 1
      fi

      checkargn $# 2

      supported_editor="vim nano emacs"

      if [ "$2" == "emacs" ] && ! command -v emacs > /dev/null; then
         echo "Emacs is not installed on this system."
         read -r -p "Do you want to have it installed? [y/N] " response
         if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
           apt install -y emacs-nox
         else
           echo "Emacs not installed."
           exit 0
         fi
      fi
      
      for i in $supported_editor; do 
        if [ "$i" == "$2" ]; then
          if ! grep EDITOR /etc/bash.bashrc | grep -q export /etc/bash.bashrc; then
            echo "export EDITOR=$i" >> /etc/bash.bashrc
          else
            sed -i -e "s/EDITOR=.*/EDITOR=$i/g" /etc/bash.bashrc
          fi 
          echo "Text editor is now $i."
          exit 0
        fi 

        if [ "$i" == "$(echo $supported_editor | grep -E -o '\S+$')" ]; then
          echo
          echo "Error: $2 is not a supported text editor."
          echo
          editor_help
          exit 1
        fi
      done
      ;;

    config)
      if [ $# -lt 2 ]; then 
        echo
        echo "Error: No config file specified."
        echo
        editor_help
        exit 1
      fi 

      checkargn $# 2

      if [ -f "$2" ]; then
        case "$EDITOR" in 
            vim)
            cp "$2" /etc/vim/vimrc.local 
            ;;
          nano)
            cp "$TEMPLATES/editor/nano/nanorc_default" /etc/nanorc 
            cat "$2" >> /etc/nanorc
            ;;
          emacs)
            ;;
        esac
        echo "$EDITOR is now using config from file \"$2\"."
        exit 0

      elif [ "$2" == "alternate" ]; then
        case "$EDITOR" in 
          vim)
            cp "$TEMPLATES/editor/vim/vimrc_alternate" /etc/vim/vimrc.local
            cp "$TEMPLATES/editor/vim/vimrc_default" /etc/vim/vimrc
            ;;
          nano)
            cp "$TEMPLATES/editor/nano/nanorc_default" /etc/nanorc 
            cat "$TEMPLATES/editor/nano/nanorc_alternate" >> /etc/nanorc
            ;;
          emacs)
            ;;
        esac
        echo "$EDITOR is now using the alternate config."
        exit 0

      elif [ "$2" == "edit" ]; then
        case "$EDITOR" in
          vim)
            vim /etc/vim/vimrc.local
            ;;
          nano)
            nano /etc/nanorc
            ;;
          emacs)
            ;;
        esac
        exit 0

      elif [ "$2" == "default" ]; then
        case "$EDITOR" in 
          vim)
            cp "$TEMPLATES/editor/vim/vimrc_default" /etc/vim/vimrc 
            rm -rf /etc/vim/vimrc.local
            ;;
          nano)
            cp "$TEMPLATES/editor/nano/nanorc_default" /etc/nanorc 
            ;;
          emacs)
            ;;
        esac
        echo "$EDITOR config reset to default."
        exit 0

      else
        echo
        echo "Error: No such option as \"$2\"."
        echo "Usages: \"$BASENAME editor config [/path/to/file]\""
        echo "        \"$BASENAME editor config [default/alternate]\""
        echo "        \"$BASENAME editor config edit\""
        echo
        exit 1
      fi
      ;;

    *)
      echo 
      echo "Error: No such option as \"$1\"."
      echo
      editor_help
      exit 1
      ;;
  esac
}

function editor_help {
  echo 
  echo "Usage: $BASENAME editor [default|set|config]"
  echo 
  echo "       $BASENAME editor                         returns the default editor"
  echo
  echo "       $BASENAME editor default                 sets vim as default editor and resets config"
  echo 
  echo "       $BASENAME editor set [vim|emacs|nano]    sets the default editor"
  echo 
  echo "       $BASENAME editor config [/path/to/file]  sets a file as the config of current editor"
  echo "       $BASENAME editor config default          uses default config for current editor"
  echo "       $BASENAME editor config alternate        uses alternate config for current editor"
  echo "       $BASENAME editor config edit             edit config of the current editor"
  echo 
}
