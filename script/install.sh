#!/usr/bin/env bash

# Uncomment the following three line have to be uncommented if Updation of Arduino alone is done seperately
#sudo apt-get update
#sudo apt-get upgrade
#sudo apt-get dist-upgrade

#if grep -q "deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi" /etc/apt/sources.list; then
#echo 'deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi'


###*******Install.sh Starts+**********###


echo "  _____            _                                ";
echo " |  __ \          | |                               ";
echo " | |  | | _____  _| |_ ___ _ __                     ";
echo " | |  | |/ _ \ \/ / __/ _ \ '__|                    ";
echo " | |__| |  __/>  <| ||  __/ |                       ";
echo " |_____/ \___/_/\_\\__\___|_| _        _            ";
echo " |_   _|         | |         | |      (_)           ";
echo "   | |  _ __   __| |_   _ ___| |_ _ __ _  ___  ___  ";
echo "   | | | '_ \ / _\` | | | / __| __| '__| |/ _ \/ __|";
echo "  _| |_| | | | (_| | |_| \__ \ |_| |  | |  __/\__ \ ";
echo " |_____|_| |_|\__,_|\__,_|___/\__|_|  |_|\___||___/ ";
echo "                                                    ";
echo "                                                    ";
echo " "
printf "Welcome to Arduberry Installer.\nPlease ensure internet connectivity before running this script.\n
NOTE: Raspberry Pi wil reboot after completion."
printf "Special thanks to Joe Sanford at Tufts University.  This script was derived from his work.  Thank you Joe!"
printf " "
echo "Must be running as Root user"
echo " "
echo "Press ENTER to begin..."
# read
sleep 5

echo " "
echo "Check for internet connectivity..."
echo "=================================="
wget -q --tries=2 --timeout=20 http://google.com
if [ $? -eq 0 ];then
	echo "Connected"
else
	echo "Unable to Connect, try again !!!"
	exit 0
fi

echo " "
echo "Installing Dependencies"
echo "======================="
## The following lines were taken from https://github.com/NicoHood/NicoHood.github.io/wiki/Installing-avr-gcc-4.8.1-and-Arduino-IDE-1.6-on-Raspberry-Pi
chmod 777 /etc/apt/sources.list
# to clear the contents in /etc/apt/sources.list
cat /dev/null > /etc/apt/sources.list
# add these lines at the bottom (Ctrl + X, Y, Enter):

echo "deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi" >> /etc/apt/sources.list
echo "deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi" >> /etc/apt/sources.list
##
# install the newest avr-gcc first
sudo apt-get -t jessie install gcc-avr -y
# install missing packages for the IDE (say yes to the message)
sudo apt-get -t jessie install avrdude avr-libc libjssc-java libastylej-jni libcommons-exec-java libcommons-httpclient-java libcommons-logging-java libjmdns-java libjna-java libjsch-java -y
sudo apt-get update
sudo apt-get install python-pip git libi2c-dev python-serial python-rpi.gpio i2c-tools python-smbus minicom -y
echo "Dependencies installed"

# install the arduino IDE
## The following lines were taken from https://github.com/NicoHood/NicoHood.github.io/wiki/Installing-avr-gcc-4.8.1-and-Arduino-IDE-1.6-on-Raspberry-Pi

sudo wget https://github.com/NicoHood/Arduino-IDE-for-Raspberry/releases/download/1.6.0-RC-1/arduino_1.6.0_all.deb
sudo wget https://github.com/NicoHood/Arduino-IDE-for-Raspberry/releases/download/1.6.0-RC-1/arduino-core_1.6.0_all.deb
sudo dpkg -i arduino-core_1.6.0_all.deb arduino_1.6.0_all.deb

# create fake directory and symbolic link to the new avrdude config
sudo mkdir /usr/share/arduino/hardware/tools/avr/etc/
sudo ln -s /etc/avrdude.conf /usr/share/arduino/hardware/tools/avr/etc/avrdude.conf
echo "Arduino 1.6.0 Installed"

##
git clone git://git.drogon.net/wiringPi
cd wiringPi
./build
echo "wiringPi Installed"

echo " "
echo "Removing blacklist from /etc/modprobe.d/raspi-blacklist.conf . . ."
echo "=================================================================="
if grep -q "#blacklist i2c-bcm2708" /etc/modprobe.d/raspi-blacklist.conf; then
	echo "I2C already removed from blacklist"
else
	sudo sed -i -e 's/blacklist i2c-bcm2708/#blacklist i2c-bcm2708/g' /etc/modprobe.d/raspi-blacklist.conf
	echo "I2C removed from blacklist"
fi
if grep -q "#blacklist spi-bcm2708" /etc/modprobe.d/raspi-blacklist.conf; then
	echo "SPI already removed from blacklist"
else
	sudo sed -i -e 's/blacklist spi-bcm2708/#blacklist spi-bcm2708/g' /etc/modprobe.d/raspi-blacklist.conf
	echo "SPI removed from blacklist"
fi

#Adding in /etc/modules
echo " "
echo "Adding I2C-dev and SPI-dev in /etc/modules . . ."
echo "================================================"
if grep -q "i2c-dev" /etc/modules; then
	echo "I2C-dev already there"
else
	echo i2c-dev >> /etc/modules
	echo "I2C-dev added"
fi
if grep -q "i2c-bcm2708" /etc/modules; then
	echo "i2c-bcm2708 already there"
else
	echo i2c-bcm2708 >> /etc/modules
	echo "i2c-bcm2708 added"
fi
if grep -q "spi-dev" /etc/modules; then
	echo "spi-dev already there"
else
	echo spi-dev >> /etc/modules
	echo "spi-dev added"
fi

cd /tmp
#wget http://project-downloads.drogon.net/gertboard/setup.sh
##*******Setup.sh Starts**********##

#cd /tmp

doBackup() {
  cd $1
  echo -n " $2: "
  if [ -f $2.bak ]; then
    echo "Backup of $2 exists, not overwriting"
  else
    mv $2 $2.bak
    mv /tmp/$2 .
    echo "OK"
  fi
}

echo "Setting up Raspberry Pi to make it work with the Gertboard"
echo "and the ATmega chip on-board with the Arduino IDE."
echo ""
echo "Checking ..."

echo -n "  Avrdude: "
if [ ! -f /usr/share/arduino/hardware/tools/avr/etc/avrdude.conf ]; then
  echo "Not installed. Please install it first"
  exit 1
fi

fgrep -sq GPIO /usr/share/arduino/hardware/tools/avr/etc/avrdude.conf
if [ $? != 0 ]; then
  echo "No GPIO support. Please make sure you install the right version"
  exit 1
fi
echo "OK"

echo -n "  Arduino IDE: "
if [ ! -f /usr/share/arduino/hardware/arduino/avr/programmers.txt ]; then
  echo "Not installed. Please install it first"
  exit 1
fi
echo "OK"

echo "Fetching files:"
for file in boards.txt programmers.txt avrsetup ; do
  echo "  $file"
  rm -f $file
  wget -q http://project-downloads.drogon.net/gertboard/$file
done

echo "Replacing/updating files:"

rm -f /usr/local/bin/avrsetup
mv /tmp/avrsetup /usr/local/bin
chmod 755 /usr/local/bin/avrsetup

cd /etc
echo -n "inittab: "
if [ -f inittab.bak ]; then
  echo "Backup exists: not overwriting"
else
  cp -a inittab inittab.bak
  sed -e 's/^.*AMA0.*$/#\0/' < inittab > /tmp/inittab.$$
  mv /tmp/inittab.$$ inittab
  echo "OK"
fi

cd /boot
echo -n "cmdline.txt: "
if [ -f cmdline.txt.bak ]; then
  echo "Backup exists: not overwriting"
else
  cp -a cmdline.txt cmdline.txt.bak
  cat cmdline.txt					|	\
		sed -e 's/console=ttyAMA0,115200//'	|	\
		sed -e 's/console=tty1//'		|	\
		sed -e 's/kgdboc=ttyAMA0,115200//' > /tmp/cmdline.txt.$$
  mv /tmp/cmdline.txt.$$ cmdline.txt
  echo "OK"
fi

doBackup /usr/share/arduino/hardware/arduino/avr boards.txt
doBackup /usr/share/arduino/hardware/arduino/avr programmers.txt

echo "All Done."
echo "Check and reboot now to apply changes."
exit 0
##******Setup.sh Ends***********##
#chmod +x setup.sh
#sudo ./setup.sh

cd /etc/minicom
sudo wget http://project-downloads.drogon.net/gertboard/minirc.ama0
sudo sed -i '/Exec=arduino/c\Exec=gksu arduino' /usr/share/applications/arduino.desktop
echo " "
echo "Please restart to implement changes!"
echo "  _____  ______  _____ _______       _____ _______ "
echo " |  __ \|  ____|/ ____|__   __|/\   |  __ \__   __|"
echo " | |__) | |__  | (___    | |  /  \  | |__) | | |   "
echo " |  _  /|  __|  \___ \   | | / /\ \ |  _  /  | |   "
echo " | | \ \| |____ ____) |  | |/ ____ \| | \ \  | |   "
echo " |_|  \_\______|_____/   |_/_/    \_\_|  \_\ |_|   "
echo " "
echo "Please restart to implement changes!"
echo "To Restart type sudo reboot"
###******Install.sh ends***********###