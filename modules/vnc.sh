#!/bin/bash

function vnc {
  status=$1
  if [ ! -d /usr/share/doc/realvnc-vnc-server ] ; then
    echo "Error: the vnc server is not installed, to install it run:"
    echo "apt-get install realvnc-vnc-server"
    exit 1;
  fi

  if [ "$status" = "on" ]; then
    enable_service vncserver-x11-serviced.service
    start_service vncserver-x11-serviced.service
    sudo sed -i '$ a hdmi_group=2' /boot/config.txt
    sudo sed -i '$ a hdmi_mode=82' /boot/config.txt
    sudo sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/' /boot/config.txt
    sudo update-rc.d lightdm enable 2
    reboot_needed
    echo "Success: the vnc service has been started and enabled when the system boots"
  elif [ "$status" = "off" ]; then
    disable_service vncserver-x11-serviced.service
    stop_service vncserver-x11-serviced.service    
    sudo sed -i '/hdmi_group=2/d' /boot/config.txt
    sudo sed -i '/hdmi_mode=82/d' /boot/config.txt
    sudo sed -i 's/hdmi_force_hotplug=1/#hdmi_force_hotplug=1/' /boot/config.txt
    sudo update-rc.d lightdm disable 2
    reboot_needed
    echo "Success: the vnc service has been stopped and disabled when the system boots."
  else
    echo "Error: only 'on', 'off' options are supported";
  fi
}

function vnc_help {
  echo ""
  echo "Usage: $(basename "$0") vnc <on|off>"
  echo ""
  echo "Enables or disables the VNC server service"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") vnc on"
  echo "      The VNC service will be enabled. This will allow devices on your network to be able to connect to the raspberry pi using VNC viewer."
  echo ""
  echo "  $(basename "$0") vnc off"
  echo "      The VNC service will be disabled."
  echo ""
} 
