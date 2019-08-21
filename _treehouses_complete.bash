#!/bin/bash

_treehouses_complete()
{
  local cur prev

  # Valid top-level completions
  commands="ap apchannel bluetooth bootoption bridge burn button clone container \ 
              coralenv default detect detectrpi ethernet expandfs feedback help \
              image internet led locale memory networkmode ntp  openvpn password \
              rebootneeded rename restore rtc services ssh sshkey sshtunnel staticwifi \
              timezone tor upgrade version vnc wifi wificountry" 
       	
  ap_cmdas="local internet"
  apchannel_cmds="1 2 3 4 5 6 7 8 9 10 11"
  bluetooth_cmds="on off pause"
  bootoption_cmds="console desktop"
  bootoption_second_cmds="autologin"
  button_cmds="off bluetooth"
  container_cmds="none docker balena"
  coralenv_cmds="install demo-on demo-off demo-always-on"
  help_cmds="ap apchannel bluetooth bootoption bridge burn button clone container \ 
              coralenv default detect detectrpi ethernet expandfs feedback help \
              image internet led locale memory networkmode ntp  openvpn password \
              rebootneeded rename restore rtc services ssh sshkey sshtunnel staticwifi \
              timezone tor upgrade version vnc wifi wificountry" 
  led_cmds="green red mode"
  memory_cmds="total used free"
  networkmode_cmds="info"
  ntp_cmds="local internet"
  openvpn_cmds="use show delete notice start stop load"
  rtc_cmds="on off"
  rtc_on_cmds="ds3231 rasclock"

# services_cmds="" Think about it, a little bit complicated

  sshkey_cmds="add list delete deleteal addgithubusername addgithubgroup"
  ssh_cmds="on off"
  sshtunnel_cmds="add remove list key notice"
  tor_cmds="start stop add list notice destroy"
  notice_cmds="on off add delete list"

# upgrade_cmds="" I am not sure whether we should put autocompletion here.

vnc_cmds="on off info"


  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  if [ $COMP_CWORD -eq 1 ]
  then
    COMPREPLY=( $(compgen -W "${commands}" -- $cur) )
  elif [ $COMP_CWORD -eq 2 ]
  then
    case "$prev" in
      "ap")
        COMPREPLY=( $(compgen -W "$ap_cmds" -- $cur) ) 
        ;;
      "apchannel")
        COMPREPLY=( $(compgen -W "$apchannel_cmds" -- $cur) ) #cannot ascending order 
        ;;
      "bluetooth")
        COMPREPLY=( $(compgen -W "$bluetooth_cmds" -- $cur) )
        ;;
      "bootoption")
        COMPREPLY=( $(compgen -W "$bootoption_cmds" -- $cur) )
        ;;
      "button")
        COMPREPLY=( $(compgen -W "$button_cmds" -- $cur) )
        ;;
      "container")
        COMPREPLY=( $(compgen -W "$container_cmds" -- $cur) )
        ;;
      "coralenv")
        COMPREPLY=( $(compgen -W "$coralenv_cmds" -- $cur) )
        ;;
      "help")
        COMPREPLY=( $(compgen -W "$help_cmds" -- $cur) )
        ;;
      "led")
        COMPREPLY=( $(compgen -W "$led_cmds" -- $cur) )
        ;;
      "memory")
        COMPREPLY=( $(compgen -W "$memory_cmds" -- $cur) )
        ;;
      "networkmode")
        COMPREPLY=( $(compgen -W "$networkmode_cmds" -- $cur) )
        ;;
      "ntp")
        COMPREPLY=( $(compgen -W "$ntp_cmds" -- $cur) )
        ;;
      "openvpn")
        COMPREPLY=( $(compgen -W "$openvpn_cmds" -- $cur) ) 
        ;;
      "rtc")
        COMPREPLY=( $(compgen -W "$rtc_cmds" -- $cur) )
        ;;
      "sshkey")
        COMPREPLY=( $(compgen -W "$sshkey_cmds" -- $cur) )
        ;;
      "ssh")
        COMPREPLY=( $(compgen -W "$ssh_cmds" -- $cur) )
        ;;
      "sshtunnel")
        COMPREPLY=( $(compgen -W "$sshtunnel_cmds" -- $cur) ) 
        ;;
      "tor")
        COMPREPLY=( $(compgen -W "$tor_cmds" -- $cur) ) 
        ;;
      "vnc")
        COMPREPLY=( $(compgen -W "$vnc_cmds" -- $cur) )
        ;;
      "*")
        ;;
    esac
  elif [ $COMP_CWORD -eq 3 ]
  then
    case "$prev" in
      "console")
        COMPREPLY=( $(compgen -W "$bootoption_second_cmds" -- $cur) )
        ;;
      "desktop")
        COMPREPLY=( $(compgen -W "$bootoption_second_cmds" -- $cur) )
        ;;
      "notice")
        COMPREPLY=( $(compgen -W "$notice_cmds" -- $cur) )
        ;;
      "*")
        ;;
    esac
  fi

}
	complete -F _treehouses_complete treehouses 
