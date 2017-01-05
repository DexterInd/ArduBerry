#!/usr/bin/env bash
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
	wget -q --tries=2 --timeout=20 --output-document=/dev/null https://raspberrypi.org 
	if [ $? -eq 0 ];then
		echo "Connected"
	else
		echo "Unable to Connect, try again !!!"
		exit 0
	fi
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
	echo "Please restart to implement changes!"
	echo "To Restart type sudo reboot"
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

# Create AVRDUDE folder if already not present  
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
        
        pushd $DIRECTORY
        git clone https://github.com/DexterInd/AVRDUDE.git
        popd
    fi
}

# Install Avrdude 5.1 from Dexter repos
install_avrdude(){
    pushd /home/pi/Dexter/lib/AVRDUDE/avrdude
    #No need to wget since files should be there in the avrdude folder
    # wget https://github.com/DexterInd/AVRDUDE/raw/master/avrdude/avrdude_5.10-4_armhf.deb
    sudo dpkg -i avrdude_5.10-4_armhf.deb 
    sudo chmod 4755 /usr/bin/avrdude
    
    # wget http://project-downloads.drogon.net/gertboard/setup.sh
    chmod +x setup.sh
    sudo ./setup.sh  
    
    # pushd /etc/minicom
    # sudo wget http://project-downloads.drogon.net/gertboard/minirc.ama0
    sudo sed -i '/Exec=arduino/c\Exec=gksu arduino' /usr/share/applications/arduino.desktop
    echo " "
    popd
}

install_arduino_avrdude_wheezy(){
    echo " "
    echo "Installing Dependencies"
    echo "======================="
    sudo apt-get install python-pip git libi2c-dev python-serial python-rpi.gpio i2c-tools python-smbus arduino minicom -y
    echo "Dependencies installed"
    
    #Updating AVRDUDE
    FILENAME=tmpfile.txt
    AVRDUDE_VER=5.10
    avrdude -v &> $FILENAME
    if grep -q $AVRDUDE_VER $FILENAME 
    then
        echo "avrdude" $AVRDUDE_VER "Found"
    else
        echo "avrdude" $AVRDUDE_VER "Not Found,Installing avrdude now"
        create_avrdude_folder
        install_avrdude
    fi
    rm $FILENAME
    
    sudo cp /home/pi/Desktop/ArduBerry/script/programmers.txt /usr/share/arduino/hardware/arduino/programmers.txt
}
#Install wiring pi (from here: https://github.com/DexterInd/GrovePi/blob/master/Script/install.sh#L85-L102)
install_wiringpi(){
    # Check if WiringPi Installed
    # Check if WiringPi Installed and has the latest version.  If it does, skip the step.
    version=`gpio -v`       # Gets the version of wiringPi installed
    set -- $version         # Parses the version to get the number
    WIRINGVERSIONDEC=$3     # Gets the third word parsed out of the first line of gpio -v returned.
                                            # Should be 2.36
    echo $WIRINGVERSIONDEC >> tmpversion    # Store to temp file
    VERSION=$(sed 's/\.//g' tmpversion)     # Remove decimals
    rm tmpversion                           # Remove the temp file

    echo "VERSION is $VERSION"
    if [ $VERSION -eq '236' ]; then

        echo "FOUND WiringPi Version 2.32 No installation needed."
    else
        echo "Did NOT find WiringPi Version 2.32"
        # Check if the Dexter directory exists.
        DIRECTORY='/home/pi/Dexter'
        if [ -d "$DIRECTORY" ]; then
            # Will enter here if $DIRECTORY exists, even if it contains spaces
            echo "Dexter Directory Found!"
        else
            mkdir $DIRECTORY
        fi
        # Install wiringPi
        cd $DIRECTORY 	# Change directories to Dexter
        git clone https://github.com/DexterInd/wiringPi/  # Clone directories to Dexter.
        cd wiringPi
        sudo chmod +x ./build
        sudo ./build
        echo "wiringPi Installed"
    fi
}

if [[ -f /home/pi/quiet_mode ]]
then
quiet_mode=1
else
quiet_mode=0
fi

if [[ "$quiet_mode" -eq "0" ]]
then
	print_start_info
fi
 
install_wiringpi

install_arduino_avrdude_wheezy
 
update_settings
 

echo " "
if [[ "$quiet_mode" -eq "0" ]]
then
    print_end_info
fi 