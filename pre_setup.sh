#!/bin/bash

e="echo -e"
bg="\e[1;34m"
ed="\e[0m"
#apps="virtualbox-6.1 vagrant"

# For virtualbox, alternatively download and add key with below command
#wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

appcheck(){
    dpkg -s $1 &>/dev/null
    #set -e
    if [[ $? -ne 0 ]]; then
        $e "$bg $1 is not installed $ed"
        if [[ $1 == "virtualbox" ]]; then 
            curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
            sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) main"
        elif [[ $1 == "vagrant" ]]; then
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
            sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        fi
        sudo apt-get update && sudo apt-get install $1 -y
        $e "$bg $1 has been installed $ed"
    else
        $e "$bg $1 is already installed $ed"
    fi
}

appcheck virtualbox
appcheck vagrant

mkdir -p ./vag_config
cd ./vag_config && touch Vagrantfile

cat <<EOF > Vagrantfile
# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_BOX = "ubuntu/focal64"
MASTER_NAME = "kmaster"
WORKER_NAME = "kworker"
IP_SUBNET = "192.168.95."

Vagrant.configure("2") do |config|
  config.vm.box = VM_BOX
  config.vm.box_check_update = false

  config.vm.define "kube-master" do |master|
    master.vm.provider "virtualbox" do |vb|
      vb.name = MASTER_NAME
      vb.memory = 2048
      vb.cpus = 2
    end
    master.vm.hostname = MASTER_NAME
    master.vm.network "private_network", ip: IP_SUBNET + "5"
    master.vm.network "forwarded_port", guest: 22, host: 65001
    master.vm.provision "host-setup", type: "shell", path: "../host-setup.sh"
    master.vm.provision "dns-setup", type: "shell", path: "../dns-setup.sh"
  end

  config.vm.define "kube-worker" do |worker|
    worker.vm.provider "virtualbox" do |vb|
      vb.name = WORKER_NAME
      vb.memory = 2048
      vb.cpus = 2
    end
    worker.vm.hostname = WORKER_NAME
    worker.vm.network "private_network", ip: IP_SUBNET + "6"
    worker.vm.network "forwarded_port", guest: 22, host: 65002
    worker.vm.provision "host-setup", type: "shell", path: "../host-setup.sh"
    worker.vm.provision "dns-setup", type: "shell", path: "../dns-setup.sh"
  end
end
EOF
$e "$bg Vagrantfile created and filled with setup $ed"

#vagrant up
# Run with --provision flag as below if the Vagrantfile is modified after a previous run of this script
vagrant up --provision