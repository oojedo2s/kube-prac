# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_BOX = "ubuntu/focal64"
MASTER_NAME = "kube-master"
WORKER_NAME = "kube-worker"
WORKER_NUM = 2    # any change to this should also be made in the host-setup.sh & ansible/hosts.yml files
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
    master.vm.provision "host-setup", type: "shell", path: "./host-setup.sh"
    master.vm.provision "dns-setup", type: "shell", path: "./dns-setup.sh"
    master.vm.provision "de-key_date", type: "shell", path: "./de-key_date.sh"
    master.vm.provision "k8s-user", type: "shell", path: "./k8s-user.sh"
    master.vm.provision "shell" do |ssh|
      public_key = File.readlines("kube_rsa.pub").first.strip
      ssh.inline = <<-SHELL
        echo #{public_key} >> /home/k8s/.ssh/authorized_keys
      SHELL
    end
    master.vm.provision "ansible" do |ansible|
      ansible.playbook = "./ansible/master.yml"
      ansible.inventory_path = "./ansible/hosts.yml"
      ansible.config_file = "./ansible/ansible.cfg"
    end
  end

  (1..WORKER_NUM).each do |i|
    config.vm.define "kube-worker#{i}" do |worker|
      worker.vm.provider "virtualbox" do |vb|
        vb.name = WORKER_NAME + "#{i}"
        vb.memory = 2048
        vb.cpus = 2
      end
      worker.vm.hostname = WORKER_NAME + "#{i}"
      worker.vm.network "private_network", ip: IP_SUBNET + "#{i + 5}"
      worker.vm.network "forwarded_port", guest: 22, host: "#{i + 65001}"
      worker.vm.provision "host-setup", type: "shell", path: "./host-setup.sh"
      worker.vm.provision "dns-setup", type: "shell", path: "./dns-setup.sh"
      worker.vm.provision "de-key_date", type: "shell", path: "./de-key_date.sh"
      worker.vm.provision "k8s-user", type: "shell", path: "./k8s-user.sh"
      worker.vm.provision "shell" do |ssh|
        public_key = File.readlines("kube_rsa.pub").first.strip
        ssh.inline = <<-SHELL
          echo #{public_key} >> /home/k8s/.ssh/authorized_keys
        SHELL
      end
      worker.vm.provision "ansible" do |ansible|
        ansible.playbook = "./ansible/worker.yml"
        ansible.inventory_path = "./ansible/hosts.yml"
        ansible.config_file = "./ansible/ansible.cfg"
      end
    end
  end
end
