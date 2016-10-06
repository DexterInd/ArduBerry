#!/usr/bin/env bash

# Installs the Arduino IDE
sudo chmod +x /home/pi/Desktop/ArduBerry/script/install_jessie.sh
sudo chmod +x /home/pi/Desktop/ArduBerry/script/install_wheezy.sh
# To Select the Arduino Install File
if cat /etc/*-release | grep -q 'jessie'
then
sudo sh /home/pi/Desktop/ArduBerry/script/install_jessie.sh
else
sudo sh /home/pi/Desktop/ArduBerry/script/install_wheezy.sh
fi

