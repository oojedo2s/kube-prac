#!/bin/bash

set -e
# IFNAME="enp0s8"
# ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
# sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts
# sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

cat >> /etc/hosts <<EOF
192.168.95.5  kube-master kube-master.local
192.168.95.6  kube-worker1 kube-worker1.local
192.168.95.7  kube-worker2 kube-worker2.local
EOF