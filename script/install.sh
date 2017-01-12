#!/usr/bin/env bash
curl --silent https://raw.githubusercontent.com/DexterInd/script_tools/master/install_script_tools.sh | bash
source /home/pi/Dexter/lib/Dexter/script_tools/functions_library.sh
print_start_info(){
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
	echo " "
	echo "Must be running as Root user"
	echo " "
	echo "Press ENTER to begin..."
	# read
	sleep 5

	echo " "
	echo "Check for internet connectivity..."
	echo "=================================="
	wget -q --tries=2 --timeout=100 --output-document=/dev/null https://raspberrypi.org 
	if [ $? -eq 0 ];then
		echo "Connected"
	else
		echo "Unable to Connect, try again !!!"
		exit 0
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

#     echo "VERSION is $VERSION"
#     if [ $VERSION -eq '236' ]; then

#         feedback "FOUND WiringPi Version 2.32 No installation needed."
#     else
#         echo "Did NOT find WiringPi Version 2.32"
#         # Check if the Dexter directory exists.
#         DIRECTORY='/home/pi/Dexter'
#         if [ -d "$DIRECTORY" ]; then
#             # Will enter here if $DIRECTORY exists, even if it contains spaces
#             echo "Dexter Directory Found!"
#         else
#             mkdir $DIRECTORY
#         fi
#         # Install wiringPi
#         cd $DIRECTORY 	# Change directories to Dexter
#         git clone https://github.com/DexterInd/wiringPi/  # Clone directories to Dexter.
#         cd wiringPi
#         sudo chmod +x ./build
#         sudo ./build
#         echo "wiringPi Installed"
#     fi
# }

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

# Create AVRDUDE folder. Create it if it does not exist
create_avrdude_folder(){
    AVRDUDE_DIR='/home/pi/Dexter/lib/AVRDUDE'
    if [ -d "$AVRDUDE_DIR" ]; then
        echo $AVRDUDE_DIR" Found!"
    else 
        DIRECTORY='/home/pi/Dexter'
        if [ -d "$DIRECTORY" ]; then
            # Will enter here if $DIRECTORY exists, even if it contains spaces
            echo $DIRECTORY" Directory Found !"
        else
            echo "creating "$DIRECTORY
            mkdir $DIRECTORY
        fi

        DIRECTORY='/home/pi/Dexter/lib'
        if [ -d "$DIRECTORY" ]; then
            # Will enter here if $DIRECTORY exists, even if it contains spaces
            echo $DIRECTORY" Directory Found!"
        else
            echo "creating "$DIRECTORY
            mkdir $DIRECTORY
        fi
        
        pushd $DIRECTORY > /dev/null
        git clone https://github.com/DexterInd/AVRDUDE.git
        popd > /dev/null
    fi
}

# Install Avrdude 5.1 from Dexter repos
install_avrdude(){
    #Updating AVRDUDE
    FILENAME=tmpfile.txt
    AVRDUDE_VER=5.10
    avrdude -v &> $FILENAME
    
    #Only install avrdude 5.1 if it does not exist
    if grep -q $AVRDUDE_VER $FILENAME 
    then
        feedback "avrdude" $AVRDUDE_VER "Found"
    else
        feedback "avrdude" $AVRDUDE_VER "Not Found,Installing avrdude now"
        create_avrdude_folder
        
        ##########################################
        #Installing AVRDUDE
        ##########################################
        pushd /home/pi/Dexter/lib/AVRDUDE/avrdude > /dev/null
        
        # Install the avrdude deb package
        # No need to wget since files should be there in the avrdude folder
        # wget https://github.com/DexterInd/AVRDUDE/raw/master/avrdude/avrdude_5.10-4_armhf.deb
        sudo dpkg -i avrdude_5.10-4_armhf.deb 
        sudo chmod 4755 /usr/bin/avrdude
        
        # Setup config files 
        # wget http://project-downloads.drogon.net/gertboard/setup.sh
        chmod +x setup.sh
        sudo bash ./setup.sh  
        
        # pushd /etc/minicom > /dev/null
        # sudo wget http://project-downloads.drogon.net/gertboard/minirc.ama0
        # sudo sed -i '/Exec=arduino/c\Exec=sudo arduino' /usr/share/applications/arduino.desktop
        echo " "
        popd > /dev/null
    fi
    delete_file $FILENAME   
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

    ###########################################
    # Install custom Arduino IDE for jessie  
    ###########################################
    # install the arduino IDE
    ## The following lines were taken from https://github.com/NicoHood/NicoHood.github.io/wiki/Installing-avr-gcc-4.8.1-and-Arduino-IDE-1.6-on-Raspberry-Pi to update the Arduino IDE to 1.6.0
    
    # sudo chmod +x /home/pi/Dexter/lib/Dexter/script_tools/install_avrdude.sh
    source /home/pi/Dexter/lib/Dexter/script_tools/install_avrdude.sh
    create_avrdude_folder
    install_avrdude
    
    pushd /home/pi/Dexter/lib/AVRDUDE/ArduinoIDE > /dev/null
    feedback "This next step takes a little while. Please be patient"
    sudo dpkg -i arduino-core_1.6.0_all.deb arduino_1.6.0_all.deb

    # create fake directory and symbolic link to the new avrdude config
    create_folder /usr/share/arduino/hardware/tools/avr/etc/
    sudo ln -s /etc/avrdude.conf /usr/share/arduino/hardware/tools/avr/etc/avrdude.conf
    feedback "Arduino 1.6.0 Installed"
    popd
    
    delete_file /usr/share/arduino/hardware/arduino/avr/programmers.txt
    sudo cp /home/pi/Dexter/ArduBerry/script/programmers.txt /usr/share/arduino/hardware/arduino/avr/programmers.txt
    sudo sed -i '/Exec=arduino/c\Exec=sudo arduino' /usr/share/applications/arduino.desktop
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

    sudo cp /home/pi/Desktop/ArduBerry/script/programmers.txt /usr/share/arduino/hardware/arduino/programmers.txt
    
    # Copy serial port access rules
    sudo cp /home/pi/Desktop/ArduBerry/script/80-arduberry.rules /etc/udev/rules.d/80-arduberry.rules
}
#####################################
#MAIN SCRIPT STARTS HERE
#####################################

if quiet_mode
then
    print_start_info
fi

print_robot_info

# First install wiring Pi
curl --silent https://raw.githubusercontent.com/DexterInd/script_tools/master/install_script_tools.sh | sudo bash

# sudo chmod +x /home/pi/Dexter/lib/Dexter/script_tools/update_wiringpi.sh
sudo bash /home/pi/Dexter/lib/Dexter/script_tools/update_wiringpi.sh

# install_wiringpi

# Select b/w Jessie and Wheezy installations for avrdude and Arduino IDE
if cat /etc/*-release | grep -q 'jessie'
then
    install_arduino_avrdude_jessie  
else
    install_arduino_avrdude_wheezy   
fi

update_settings

echo " "
if quiet_mode
then
	print_end_info
fi