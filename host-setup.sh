#!/bin/bash

set -e
IFNAME="enp0s8"
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

cat >> /etc/hosts <<EOF
192.168.95.5  master
192.168.95.6  worker
EOF