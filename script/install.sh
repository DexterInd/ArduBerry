#!/usr/bin/env bash

# To Select the Arduino Install File
if cat /etc/*-release | grep -q 'jessie'
then
sudo bash /home/pi/Desktop/ArduBerry/script/install_jessie.sh
else
sudo bash /home/pi/Desktop/ArduBerry/script/install_wheezy.sh
fi

