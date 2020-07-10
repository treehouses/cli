# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  BOX = "treehouses/buster64"
  BOX_VERSION = "0.13.25"

  config.vm.define "cli" do |cli|
    cli.vm.box = BOX
    cli.vm.box_version = BOX_VERSION

    cli.vm.hostname = "cli"

    cli.vm.provider "virtualbox" do |vb|
      vb.name = "cli"
      vb.memory = "666"
    end

    # there are known problems with certain verions or vagrant/virtualbox for windows, feel free to switch the comment
    cli.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true
    #cli.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "127.0.0.1", id: "ssh", auto_correct: true

    # Prevent TTY Errors (copied from laravel/homestead: "homestead.rb" file)... By default this is "bash -l".
    cli.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    cli.vm.provision "shell", inline: <<-SHELL
      ln -sr /vagrant /root/cli
      ln -sr /vagrant /home/vagrant/cli
      #windows
      dos2unix /vagrant/*/*/*/* /vagrant/*/*/* /vagrant/*/* /vagrant/*
    SHELL

    # Run binding on each startup make sure the mount is available on VM restart
    cli.vm.provision "shell", run: "always", inline: <<-SHELL
    SHELL
  end

end
