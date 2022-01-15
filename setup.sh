#!/bin/bash

e="echo -e"
bg="\e[1;34m"
ed="\e[0m"

# For virtualbox, alternatively download and add key with below command
#wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

appcheck(){
    dpkg -s $1 &>/dev/null

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

# Generate kube user ssh key
ssh-keygen -t rsa -b 4096 -f ./kube_rsa -N "" -q

vagrant up
# Run with --provision flag as below if the Vagrantfile is modified after a previous run of this script
#vagrant up --provision

