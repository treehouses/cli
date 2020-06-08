#! /bin/bash 

function editor {
  checkroot

  if [ -z "$EDITOR" ]; then
    echo
    echo "Default editor not set."
    echo "Use \"treehouses editor default\""
    echo "or \"treehouses editor set [vim|emacs|nano]\" to set your default editor."
    echo
    exit 1
  fi 

  if [ $# -eq 0 ]; then
    echo $EDITOR
    exit 0
  fi

  case "$1" in 
    default)
      export EDITOR=vim
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
        echo "No editor specified."
        echo
        exit 1
      fi

      case "$2" in 
        vim)
          export EDITOR=vim 
          if ! grep EDITOR /etc/bash.bashrc | grep -q export /etc/bash.bashrc; then
            echo "export EDITOR=vim" >> /etc/bash.bashrc
          else
            sed -i -e "s/EDITOR=.*/EDITOR=vim/g" /etc/bash.bashrc
          fi
          ;;
        nano)
          export EDITOR=nano
          if ! grep EDITOR /etc/bash.bashrc | grep -q export /etc/bash.bashrc; then
            echo "export EDITOR=nano" >> /etc/bash.bashrc
          else
            sed -i -e "s/EDITOR=.*/EDITOR=nano/g" /etc/bash.bashrc
          fi
          ;;
        emacs)
          ;;
        *)
          echo
          echo "$2 is not a supported text editor."
          echo
          exit 1
          ;;
      esac
      ;;

    config)
      if [ $# -lt 2 ]; then 
        echo
        echo "No config file specified."
        echo
        exit 1
      fi 

      if [ -f "$2" ]; then
        case "$EDITOR" in 
            vim)
            cp "$2" /etc/vim/vimrc.local 
            ;;
          nano)
            cp "$2" /etc/nanorc
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
            ;;
          emacs)
            ;;
        esac
      else
        echo
        echo "Arguments error."
        echo
        exit 1
      fi
      ;;

    *)
      echo 
      echo "Arguments error."
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
  echo 
}
