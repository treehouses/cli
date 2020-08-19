function tg-terminal {
  checkroot
  case $1 in
  "")
    systemctl is-active tg-terminal.service
    ;;
  "install")
    if [ -z "$2"]; then
      echo "Please pass the token as the argument"
      exit 1
    else
      tg-terminal-install "$2"
    fi
    ;;
  "start")
    systemctl start tg-terminal.service
    echo "Bot started."
    ;;
  "enable")
    systemctl enable tg-terminal.service --quiet
    echo "Bot enabled."
    ;;
  *)
    echo "No option as $1."
    exit 1
    ;;
  esac
}

function tg-terminal-install {
  echo "Installing.."
  rm -rf /srv/tg-terminal/
	mkdir -p /srv/tg-terminal/shareFolder/
	touch /srv/tg-terminal/users.txt
	touch /srv/tg-terminal/log.txt
	
	wget -q -P /srv/tg-terminal/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/telegramShellBot.py || exit 1
	wget -q -P /srv/tg-terminal/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/config.txt || exit 1
  rm -f /etc/systemd/system/tg-terminal.service
  wget -q -P /etc/systemd/system/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/tg-terminal.service || exit 1
	sed -i "s/token =/token = $1/g" /srv/tg-terminal/config.txt
	pip3 install -q pyTelegramBotApi || exit 1
  echo "tg-terminal install."	
}

function tg-terminal_help {
  echo
}
