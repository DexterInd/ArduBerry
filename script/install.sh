#!/usr/bin/env bash
echo "  __   ____  ____  _  _  ____  ____  ____  ____  _  _ "
echo " / _\ (  _ \(    \/ )( \(  _ \(  __)(  _ \(  _ \( \/ )"
echo "/    \ )   / ) D () \/ ( ) _ ( ) _)  )   / )   / )  / "
echo "\_/\_/(__\_)(____/\____/(____/(____)(__\_)(__\_)(__/  "

# To Select the Arduino Install File
if cat /etc/*-release | grep -q 'jessie'
then
sudo bash /home/pi/Desktop/ArduBerry/script/install_jessie.sh
else
sudo bash /home/pi/Desktop/ArduBerry/script/install_wheezy.sh
fi

