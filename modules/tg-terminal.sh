function tg-terminal {
  checkroot
  case $1 in
  "install")
    tg-terminal-install
    ;;
  "start")
    python3 /srv/tg-terminal/telegramShellBot.py & disown
    ;;
  *)
    echo "No option as $1."
    exit 1
    ;;
  esac
}

function tg-terminal-install {
	mkdir -p /srv/tg-terminal/shareFolder/
	touch /srv/tg-terminal/users.txt
	touch /srv/tg-terminal/log.txt
	
	wget -q -P /srv/tg-terminal/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/telegramShellBot.py || exit 1
	wget -q -P /srv/tg-terminal/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/config.txt || exit 1
	sed -i 's/token =/token = 1304518352:AAHYhhLGLZvTzXsYmt-A5oeEL6oUqCUvP6E/g' /srv/tg-terminal/config.txt
	pip3 install -q pyTelegramBotApi || exit 1
  echo "tg-terminal install."	
}

function tg-terminal_help {
  echo
}
