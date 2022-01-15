#!/bin/bash

set -e
KUBE_USER="k8s"
KUBE_USER_SSH_DIR="/home/$KUBE_USER/.ssh"
KUBE_USER_KUBE_DIR="/home/$KUBE_USER/.kube"

if id -u $KUBE_USER &>/dev/null; then
    echo "$KUBE_USER already exists"
else 
    useradd -m -s /bin/bash $KUBE_USER      # -m creates home dir, -s specifies default shell
    echo "$KUBE_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

mkdir -p $KUBE_USER_SSH_DIR $KUBE_USER_KUBE_DIR && touch $KUBE_USER_SSH_DIR/authorized_keys
