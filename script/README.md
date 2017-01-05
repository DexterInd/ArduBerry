## **Arduberry Scripts**

These files are used to set up the Arduberry on a Raspbian image. The setup process is different for Wheezy and Jessie, which is in the **install.sh** script.

Files
* **programmers.txt** - programmer definitions for the Arduino IDE
* **80-arduberry.rules** - permission added to give the Arduino IDE access to the serial port

## Install Arduino IDE
First make the install script exectuable:
> sudo chmod + install.sh

then run the script :
> sudo ./install.sh

If you are running your own image and using the Pi3, run these two lines in the terminal, to enable Serial:
> sudo echo "enable_uart=1" >> /boot/config.txt
> sudo echo "dtoverlay=pi3-miniuart-bt" >> /boot/config.txt