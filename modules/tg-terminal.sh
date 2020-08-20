function tg-terminal {
  checkroot
  case $1 in
  "" | "status")
    systemctl is-active tg-terminal.service
    ;;
  "install")
    if [ -z "$2" ]; then
      echo "Please pass the token as the argument."
      exit 1
    else
      tg-terminal-install "$2"
    fi
    ;;
  "uninstall")
    tg-terminal stop
    tg-terminal disable
    rm -rf /srv/tg-terminal/
    rm -f /etc/systemd/system/tg-terminal.service
    echo "tg-terminal uninstalled."
    ;;
  "start")
    systemctl start tg-terminal.service --quiet
    echo "Bot started."
    echo "Text your bot on Telegram \"/start\" to get started"
    ;;
  "stop")
    systemctl stop tg-terminal.service --quiet
    echo "Bot stopped."
    ;;
  "enable")
    systemctl enable tg-terminal.service --quiet
    echo "Bot enabled."
    ;;
  "disable")
    systemctl disable tg-terminal.service --quiet
    echo "Bot disabled."
    ;;
  *)
    echo "No option as $1."
    tg-terminal_help
    exit 1
    ;;
  esac
}

function tg-terminal-install {
  echo "Installing.."
  tg-terminal uninstall > /dev/null
	mkdir -p /srv/tg-terminal/shareFolder/
	touch /srv/tg-terminal/users.txt
	touch /srv/tg-terminal/log.txt
	
	wget -q -P /srv/tg-terminal/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/telegramShellBot.py || exit 1
	wget -q -P /srv/tg-terminal/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/config.txt || exit 1
  wget -q -P /etc/systemd/system/ https://raw.githubusercontent.com/darthnoward/remoteTelegramShell/master/tg-terminal.service || exit 1
	sed -i "s/token =/token = $1/g" /srv/tg-terminal/config.txt
	pip3 install -q pyTelegramBotApi || exit 1
  echo "tg-terminal installed."	
}

function tg-terminal_help {
  echo
  echo  "A bot service for terminal over Telegram."
  echo
  echo  "Usage:  $BASENAME tg-terminal <install|uninstall|enable|disable|start|stop> [token]"
  echo
  echo  "        $BASENAME tg-terminal install <token>"
  echo  "                Install tg-terminal with token given"
  echo  "                To generate a token, see https://core.telegram.org/bots#6-botfather"
  echo
  echo  "        $BASENAME tg-terminal [enable|disable|start|stop]"
  echo  "                enable/disable/start/stop the bot for terminal over Telegram"
  echo
}