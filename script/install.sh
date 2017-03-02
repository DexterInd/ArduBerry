#!/usr/bin/env bash
curl --silent https://raw.githubusercontent.com/DexterInd/script_tools/master/install_script_tools.sh | bash

PIHOME=/home/pi
DEXTERSCRIPT=$PIHOME/Dexter/lib/Dexter/script_tools
USER_ID=$(/usr/bin/id -u)
USER_NAME=$(/usr/bin/who am i | awk '{ print $1 }')
SCRIPT_PATH=$(/usr/bin/realpath $0)
DIR_PATH=$(/usr/bin/dirname ${SCRIPT_PATH} | sed 's/\/Script$//')
REPO_PATH=$(sudo find / -name "ArduBerry" | head -1)
source $DEXTERSCRIPT/functions_library.sh

print_start_info(){
	if ! quiet_mode
    then
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
		echo "Welcome to Arduberry Installer."
		echo "Please ensure internet connectivity before running this script."
		echo "NOTE: Raspberry Pi wil reboot after completion."
		echo "Special thanks to Joe Sanford at Tufts University.  This script was derived from his work.  Thank you Joe!"
	fi
}

print_robot_info(){
    echo "                  _       _                          "
    echo "    /\           | |     | |                         "
    echo "   /  \   _ __ __| |_   _| |__   ___ _ __ _ __ _   _ "
    echo "  / /\ \ | '__/ _  | | | | '_ \ / _ \ '__| '__| | | |"
    echo " / ____ \| | | (_| | |_| | |_) |  __/ |  | |  | |_| |"
    echo "/_/    \_\_|  \__,_|\__,_|_.__/ \___|_|  |_|   \__, |"
    echo "                                                __/ |"
    echo "                                               |___/ "
}

print_end_info(){
	if ! quiet_mode
    then
		echo "Please restart to implement changes!"
		echo "  _____  ______  _____ _______       _____ _______ "
		echo " |  __ \|  ____|/ ____|__   __|/\   |  __ \__   __|"
		echo " | |__) | |__  | (___    | |  /  \  | |__) | | |   "
		echo " |  _  /|  __|  \___ \   | | / /\ \ |  _  /  | |   "
		echo " | | \ \| |____ ____) |  | |/ ____ \| | \ \  | |   "
		echo " |_|  \_\______|_____/   |_/_/    \_\_|  \_\ |_|   "
		echo " "
		feedback "Please restart to implement changes!"
		feedback "To Restart type sudo reboot"
	fi
}

check_root_user() {
    if [[ $EUID -ne 0 ]]; then
        feedback "FAIL!  This script must be run as such: sudo ./install.sh"
        exit 1
    fi
    echo " "
}

check_internet() {
    if ! quiet_mode ; then
        feedback "Check for internet connectivity..."
        feedback "=================================="
        wget -q --tries=2 --timeout=20 --output-document=/dev/null http://raspberrypi.org 
        if [ $? -eq 0 ];then
            echo "Connected to the Internet"
        else
            echo "Unable to Connect, try again !!!"
            exit 0
        fi
    fi
}
# #Install wiring pi from DI repos(from here: https://github.com/DexterInd/GrovePi/blob/master/Script/install.sh#L85-L102)
# install_wiringpi(){
#     # Check if WiringPi Installed
#     # Check if WiringPi Installed and has the latest version.  If it does, skip the step.
#     version=`gpio -v`       # Gets the version of wiringPi installed
#     set -- $version         # Parses the version to get the number
#     WIRINGVERSIONDEC=$3     # Gets the third word parsed out of the first line of gpio -v returned.
#                                             # Should be 2.36
#     echo $WIRINGVERSIONDEC >> tmpversion    # Store to temp file
#     VERSION=$(sed 's/\.//g' tmpversion)     # Remove decimals
#     rm tmpversion                           # Remove the temp file

install_wiringpi() {
    # Check if WiringPi Installed

    # using curl piped to bash does not leave a file behind. no need to remove it
    # we can do either the curl - it works just fine 
    # sudo curl https://raw.githubusercontent.com/DexterInd/script_tools/master/update_wiringpi.sh | bash
    # or call the version that's already on the SD card
    sudo bash $DEXTERSCRIPT/update_wiringpi.sh
    # done with WiringPi

    # remove wiringPi directory if present
    if [ -d wiringPi ]
    then
        sudo rm -r wiringPi 
    fi
    # End check if WiringPi installed
    echo " "
}

#Update settings in /etc/modprobe.d/ and /etc/modules t enable I2C and SPI
update_settings(){
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
}

# Jessie specific arduino IDE installation
install_arduino_avrdude_jessie(){
    ###########################################
    # Install jessie specific apt repos first
    ###########################################
    
    echo " "
    feedback "Installing Dependencies"
    feedback "======================="
    # install the newest avr-gcc first
    sudo apt-get -t jessie install gcc-avr -y
    # install missing packages for the IDE (say yes to the message)
    sudo apt-get -t jessie install avr-libc libjssc-java libastylej-jni libcommons-exec-java libcommons-httpclient-java libcommons-logging-java libjmdns-java libjna-java libjsch-java -y
    sudo apt-get install python-pip git libi2c-dev python-serial python-rpi.gpio i2c-tools python-smbus minicom -y
    feedback "Dependencies installed"

    # sudo chmod +x /home/pi/Dexter/lib/Dexter/script_tools/install_avrdude.sh
    source /home/pi/Dexter/lib/Dexter/script_tools/install_avrdude.sh
	create_avrdude_folder
    install_avrdude
	
	ARDUINO_VER="$(dpkg-query -W -f='${Version}\n' arduino)"
	if [ $ARDUINO_VER == '2:1.6.0' ]; then
		feedback "FOUND Arduino IDE 1.6 No installation needed."
	else
		feedback "Did NOT find Arduino IDE"
		###########################################
		# Install custom Arduino IDE for jessie  
		###########################################
		# install the arduino IDE
		## The following lines were taken from https://github.com/NicoHood/NicoHood.github.io/wiki/Installing-avr-gcc-4.8.1-and-Arduino-IDE-1.6-on-Raspberry-Pi to update the Arduino IDE to 1.6.0
    
		pushd /home/pi/Dexter/lib/AVRDUDE/ArduinoIDE > /dev/null
		feedback "This next step takes a little while. Please be patient"
		sudo dpkg -i arduino-core_1.6.0_all.deb arduino_1.6.0_all.deb

		# create fake directory and symbolic link to the new avrdude config
		create_folder /usr/share/arduino/hardware/tools/avr/etc/
		sudo ln -s /etc/avrdude.conf /usr/share/arduino/hardware/tools/avr/etc/avrdude.conf
		feedback "Arduino 1.6.0 Installed"
		popd
		
		delete_file /usr/share/arduino/hardware/arduino/avr/programmers.txt
		sudo cp $REPO_PATH/script/programmers.txt /usr/share/arduino/hardware/arduino/avr/programmers.txt
		sudo sed -i '/Exec=arduino/c\Exec=sudo arduino' /usr/share/applications/arduino.desktop
	fi 
}

# Wheezy specific arduino IDE installation
install_arduino_avrdude_wheezy(){
    echo " "
    feedback "Installing Dependencies"
    feedback "======================="
    sudo apt-get install python-pip git libi2c-dev python-serial python-rpi.gpio i2c-tools python-smbus arduino minicom -y
    feedback "Dependencies installed"
    
    # sudo chmod +x /home/pi/Dexter/lib/Dexter/script_tools/install_avrdude.sh
    source /home/pi/Dexter/lib/Dexter/script_tools/install_avrdude.sh
    install_avrdude

    sudo cp  $REPO_PATH/script/programmers.txt /usr/share/arduino/hardware/arduino/programmers.txt
    
    # Copy serial port access rules
    sudo cp  $REPO_PATH/script/80-arduberry.rules /etc/udev/rules.d/80-arduberry.rules
}
#####################################
#MAIN SCRIPT STARTS HERE
#####################################

print_start_info
print_robot_info

check_internet
check_root_user

install_wiringpi

# Select b/w Jessie and Wheezy installations for avrdude and Arduino IDE
if cat /etc/*-release | grep -q 'jessie'
then
    install_arduino_avrdude_jessie  
else
    install_arduino_avrdude_wheezy   
fi

update_settings
sudo python $REPO_PATH/script/Serial_enable.py
print_end_info
