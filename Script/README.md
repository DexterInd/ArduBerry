## **Arduberry Scripts**

These files are used to set up the Arduberry on a Raspbian image. The setup process is different for Wheezy and Jessie, which is in the **install.sh** script.

Files
* **programmers.txt** - programmer definitions for the Arduino IDE
* **80-arduberry.rules** - permission added to give the Arduino IDE access to the serial port

## Install Arduino IDE
First run the `sudo apt-get update` to update the registries in case they are not up to date. 

Then run the script :
```
sudo bash ./install.sh
```

If you are running your own image and using the Pi3, run these two lines in the terminal, to enable Serial:

```
sudo echo "enable_uart=1" >> /boot/config.txt
sudo echo "dtoverlay=pi3-miniuart-bt" >> /boot/config.txt
```

## Quick Install

Or the easiest way for installing/updating the Arduino IDE for the Arduberry is to enter the following command (plus one extra if needed):
```
sudo apt-get update # in case the registries are not up to date
```
```
curl -kL dexterindustries.com/update_arduberry | bash
```
