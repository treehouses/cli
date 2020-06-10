#! /bin/bash 

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
      if ! grep EDITOR /etc/bash.bashrc | grep -q export /etc/bash.bashrc; then
        echo "export EDITOR=vim" >> /etc/bash.bashrc
      else
        sed -i -e "s/EDITOR=.*/EDITOR=vim/g" /etc/bash.bashrc
      fi
      cp "$TEMPLATES/editor/vim/vimrc_default" /etc/vim/vimrc 
      cp "$TEMPLATES/editor/nano/nanorc_default" /etc/nanorc
      rm -rf /etc/vim/vimrc.local
      ;;

    set)
      if [ $# -lt 2 ]; then 
        echo
        echo "Error: No editor specified."
        echo
        exit 1
      fi

      supported_editor="vim nano emacs"
      
      for i in $supported_editor; do 
        if [ "$i" == "$2" ]; then
          if ! grep EDITOR /etc/bash.bashrc | grep -q export /etc/bash.bashrc; then
            echo "export EDITOR=$i" >> /etc/bash.bashrc
          else
            sed -i -e "s/EDITOR=.*/EDITOR=$i/g" /etc/bash.bashrc
          fi 
          exit 0
        fi 
        if [ "$i" == "$(echo $supported_editor | egrep -o '\S+$')" ]; then
          echo
          echo "Error: $2 is not a supported text editor."
          echo
          exit 1
        fi
      done
      ;;

    config)
      if [ $# -lt 2 ]; then 
        echo
        echo "Error: No config file specified."
        echo
        exit 1
      fi 

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

      else
        echo
        echo "Error: No such option as $2."
        echo "Use \"$BASENAME editor config [/path/to/file]\""
        echo "or \"$BASENAME editor config [default/alternate]\""
        echo
        exit 1
      fi
      ;;

    *)
      echo 
      echo "Error: Arguments error."
      echo
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
  echo "       $BASENAME editor config [/path/to/file]  use a file as the config of the editor"
  echo "       $BASENAME editor config default          use default config for current editor"
  echo "       $BASENAME editor config alternate        use alternate config for current editor"
  echo 
}
