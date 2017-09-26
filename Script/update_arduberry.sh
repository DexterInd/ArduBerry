PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots
curl --silent https://raw.githubusercontent.com/DexterInd/script_tools/master/install_script_tools.sh | bash

# needs to be sourced from here when we call this as a standalone
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

delete_folder /home/pi/Desktop/ArduBerry       # Delete the old location

# Check for a Arduberry directory under "Dexter" folder.  If it doesn't exist, create it.
ARDUBERRY_DIR=$DEXTER_PATH/ArduBerry
if [ -d "$ARDUBERRY_DIR" ]; then
    echo "Arduberry Directory Exists"
    cd $ARDUBERRY_DIR   # Go to directory
    sudo git fetch origin       # Hard reset the git files
    sudo git reset --hard  
    sudo git merge origin/master
else
    cd $DEXTER_PATH
    git clone https://github.com/DexterInd/ArduBerry
    cd ArduBerry
fi

#Arduberry does not have a update201612 branch

sudo chmod +x $ARDUBERRY_DIR/script/install.sh
sudo bash $ARDUBERRY_DIR/script/install.sh