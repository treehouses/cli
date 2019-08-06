#!/bin/bash

function vnc {
  option=$1
  bootoptionstatus=$(systemctl is-enabled graphical.target)
  vncservicestatus=$(service vncserver-x11-serviced status | grep -q 'running')
  xservicestatus=$(service lightdm status | grep -q 'running')
  ipaddress=$(/usr/lib/vnc/get_primary_ip4)

  # Get the status of each VNC related service for status-service
  if [ "$bootoptionstatus" = "static" ]; then
    isgraphical="Console"
  elif [ "$bootoptionstatus" = "indirect" ]; then
    isgraphical="Desktop"
  fi

  if [ ! "$vncservicestatus" ]; then
    isenabledvnc="running"
    elif [ "$vncservicestatus" ]; then
    isenabledvnc="not running"
  fi

  if [ ! "$xservicestatus" ]; then
    isenabledx="running"
    elif [ "$xservicestatus" ]; then
    isenabledx="not running"
  fi

  # Checks whether we have the required package to run a VNC server
  if [ ! -d /usr/share/doc/realvnc-vnc-server ] ; then
    echo "Error: the vnc server is not installed, to install it run:"
    echo "apt-get install realvnc-vnc-server"
    exit 1;
  fi

case "$option" in
  "")
    if [ "$bootoptionstatus" = "static" ] && [ "$vncservicestatus" ] && [ "$xservicestatus" ]; then
      echo "VNC is disabled." 
      echo "To enable it, use $(basename "$0") vnc on"
    elif [ "$bootoptionstatus" = "indirect" ] && [ ! "$vncservicestatus" ] && [ ! "$xservicestatus" ]; then
      echo "You can now remotely access the system with a VNC client using the IP address: $ipaddress"
      echo "To disable it, use $(basename "$0") vnc off"
    else
      echo "VNC server is not configured correctly. Please try $(basename "$0") vnc on to enable it, or $(basename "$0") vnc off to disable it."
      echo "Alternatively, you may try $(basename "$0") vnc status-service to verify the status of each specific required service."
    fi
    ;;
  "on")
    grep -qF 'hdmi_group=2' '/boot/config.txt' || echo 'hdmi_group=2' | tee -a '/boot/config.txt'
    grep -qF 'hdmi_mode=82' '/boot/config.txt' || echo 'hdmi_mode=82' | tee -a '/boot/config.txt'
    sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/' /boot/config.txt
    enable_service vncserver-x11-serviced.service
    start_service vncserver-x11-serviced.service
    systemctl set-default graphical.target
    reboot_needed
    echo "Success: the vnc service has been started and enabled when the system boots."
    echo "You can then remotely access the system with a VNC client using the IP address: $ipaddress" 
    ;;
  "off")
    sed -i '/hdmi_group=2/d' /boot/config.txt
    sed -i '/hdmi_mode=82/d' /boot/config.txt
    sed -i 's/hdmi_force_hotplug=1/#hdmi_force_hotplug=1/' /boot/config.txt
    stop_service vncserver-x11-serviced.service
    disable_service vncserver-x11-serviced.service
    systemctl set-default multi-user.target
    reboot_needed
    echo "Success: the vnc service has been stopped and disabled when the system boots."
    ;;
  "info")
    echo "The system boots into $isgraphical"
    echo "The VNC service is $isenabledvnc"
    echo "The X window service is $isenabledx"
    echo "In order to access your desktop via a VNC viewer, the system needs to boot into Desktop, and VNC and X window services need to be running"
    if [ "$bootoptionstatus" = "static" ] || [ "$vncservicestatus" ] || [ "$xservicestatus" ]; then
      echo "Your system is not configured correctly."
      echo "You may try $(basename "$0") vnc on, or attempt to enable any missing service manually"
    fi
    ;; 
 *)
    echo "Error: only 'on', 'off', 'info' options are supported";
    exit 1;
    ;;
  esac
}

# Prints the options for the "vnc" command
function vnc_help {
  echo ""
  echo "Usage: $(basename "$0") vnc <on|off|status|status-service>"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") vnc"
  echo "      Prints the status of the VNC server (enabled or disabled)."
  echo ""
  echo "  $(basename "$0") vnc on"
  echo "      The VNC service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using VNC viewer."
  echo "      This will disable html, if it is active."
  echo ""
  echo "  $(basename "$0") vnc off"
  echo "      VNC services will be disabled."  echo ""
  echo "Enables or disables the VNC server service"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") vnc info"
  echo "      Prints a detailed configuration of each required component (boot option, vnc service, x service)."
} 
