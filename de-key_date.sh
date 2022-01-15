#!/bin/bash

set -e
# sudo update-locale LANG=de_DE.UTF-8
# echo -e 'LANG=de_DE.UTF-8\nLC_ALL=de_DE.UTF-8' > /etc/default/locale
sudo localectl set-keymap de
sudo timedatectl set-timezone Europe/Berlin