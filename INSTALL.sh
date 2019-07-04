#!/bin/bash

# https://pastebin.com/mCaHwckM
#
# SUDO-INSTAL.sh
# To be run second and only once by sudo to inatall
# DeepOnion wallet V .deb package on TAILS.
# Original content provided by @nezero
#
# https://youtu.be/EPpn9lPb0aA (original video of original script)

####  Section 1  Install the wallet (run once)

#########################################################################################
####                                                                                 ####
#### INSTALL_DeepOnion-wallet.sh                                                     ####
####                                                                                 ####
#### Execute this script only once. You will need to use sudo to execute.            ####
#### This script will install the targets of deeponion-qt and deeponiond             ####
####                                                                                 ####
#########################################################################################


### Install persistent sources
install -d -m 755 /live/persistence/TailsData_unlocked/apt-sources.list.d

### Add the sources directory to the persistence
echo "/etc/apt/sources.list.d  source=apt-sources.list.d,link" | tee --append /live/persistence/TailsData_unlocked/persistence.conf

### Add our sources to the persistent sources list.
echo "deb tor+http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main"  | tee --append /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
echo "deb [arch=amd64] tor+http://ppa.deeponion.org.uk/debian stretch main"  | tee --append /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
chown root:root /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
chmod 644 /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list
ln -s /live/persistence/TailsData_unlocked/apt-sources.list.d/deeponion.list /etc/apt/sources.list.d/deeponion.list

### Ensure DeepOnion is reinstalled each time Tails boots
echo "deeponion-qt" | tee --append /live/persistence/TailsData_unlocked/live-additional-software.conf
echo "deeponiond" | tee --append /live/persistence/TailsData_unlocked/live-additional-software.conf
apt-key add bitcoin.gpg
apt-key add pgp.key

apt-get update
apt-get install deeponion-qt deeponiond -y

### A little house cleaning
##   Do Not Uncomment the next 2 lines to auto-delete the 2 files which are needed if you may want to update
## rm /home/amnesia/Persistent/pgp.key
## rm /home/amnesia/Persistent/bitcoin.gpg

###################################################################################################################

####   Section 2  Modify the firewall and edit menu item
################################################################################
####                                                                        ####
#### The install of the wallet is now complete. Below are instructions of   ####
#### how to modify the firewall and edit the menu link                      ####
####                                                                        ####
################################################################################


### The below setup should be done on each boot. This can be done with Setup-DO.sh script at section 3 after files
### are edited and pre-positioned.
### Configure the firewall to allow DeepOnion to connect. To do this add this into /etc/ferm/ferm.conf
### Remove one (1) comment hash (#) from each of the next four (4) lines after copying.
## White-list access to DeepOnion
# daddr 127.0.0.1 proto tcp syn dport 9081 {
#  mod owner uid-owner \$amnesia_uid ACCEPT;
# }

#############################################################################################################
### Re run the firewall config.
# sudo ferm /etc/ferm/ferm.conf

### Launch DeepOnion-qT
# torsocks DeepOnion-qt -datadir=/home/amnesia/Persistent/.DeepOnion

### Alternatively, to use the menu icon modify the /usr/share/applications/DeepOnion-qt.desktop to look like this.
##  Do not put "#" in the file.
# [Desktop Entry]
# Name=DeepOnion Qt
# Comment=The GUI version of the DeepOnion wallet.
# Exec=torsocks DeepOnion-qt -datadir=/home/amnesia/Persistent/.DeepOnion
# Icon=DeepOnion
# Type=Application
# Categories=Utility;

###################################################################################################################

#### Section 3  Script to copy configuration files. To be run before starting DeepOnion Qt
############################################################################################
####   Copy the lines below into a file named Setup-DO.sh                               ####
####   Remove only the first "#" in each line.                                          ####
####   Make file exexutable $ chmod +x Setup-DO.sh                                      ####
####   Execute ./Setup-DO.sh before starting DeepOnion Qt                               ####
############################################################################################
# #!/bin/bash

# ##  Setup-DO.sh

#  
#  mkdir /home/amnesia/.config/DeepOnion
# cp /home/amnesia/Persistent/.DeepOnion/DeepOnion-Qt.conf /home/amnesia/.config/DeepOnion/DeepOnion-Qt.conf
# sudo cp /home/amnesia/Persistent/.DeepOnion/DeepOnion-qt.desktop /usr/share/applications/DeepOnion-qt.desktop

# ### Overwrite the stock firewall rules to allow DeepOnion and restart firewall
# sudo cp /home/amnesia/Persistent/.DeepOnion/ferm/ferm.conf /etc/ferm/ferm.conf
# sudo ferm /etc/ferm/ferm.conf


###########################################################################
##  Links:

# https://www.deeponion.org
# https://deeponion.org/quicksync.html
# https://deeponion.org/DeepOnion.conf.php
# https://deeponion.org/community/threads/official-tails-debian-and-ubuntu-install-guide.39319/
#

#######################################################################################################
#######################################################################################################
#######################################################################################################
####################### SPLIT BELOW THIS LINE #########################################################

#!/bin/bash

# https://pastebin.com/Qpx8BKFB
#
# USER-INSTALL.sh
# To be run first and only once by normal user to install
# DeepOnion wallet V .deb package on TAILS.
# Original content provided by @nezero
#
mkdir -p /home/amnesia/Persistent/.DeepOnion
wget http://ppa.deeponion.org.uk/bitcoin.gpg
wget http://ppa.deeponion.org.uk/pgp.key

########################################################################################################
########################################################################################################
################################## START WALLET AFTER REBOOT ###########################################
########################################################################################################

#!/bin/bash
# DEEPONION-START.sh
# https://pastebin.com/GELGxku8
######################################################################################
##                            IMPORTANT !!!                                         ##
#  DO NOT USE THIS SCRIPT until files are modified and saved in appropriate places.  #
######################################################################################

# Start_DO-wallet.sh
# To be run after each reboot to perform prepatory changes of firewall
# and menu item link and start wallet with previously saved settings.
# Original content from content by @nezero 
# Firewall changes from content by @dragononcrypto

# https://youtu.be/EPpn9lPb0aA

#  The files for this script must be pre-modified and pre-positioned to be copied
#  to apropriate places.
#  Important dirs are:
#  /home/amnesia/Persistent/.DeepOnion
#  /home/amnesia/Persistent/.DeepOnion/ferm
#  Important files to have modified:
#  ferm.conf
#  DeepOnion-qt.desktop 
#  DeepOnion-Qt.conf  (This file should ONLY be modified from within the wallet
#                     and then copied to /home/amnesia/Persistent/.DeepOnion/ )
#
######################################################################################
##                            IMPORTANT !!!                                         ##
#  DO NOT USE THIS SCRIPT until files are modified and saved in appropriate places.  #
######################################################################################
### 
mkdir /home/amnesia/.config/DeepOnion
cp /home/amnesia/Persistent/.DeepOnion/DeepOnion-Qt.conf /home/amnesia/.config/DeepOnion/DeepOnion-Qt.conf
sudo cp /home/amnesia/Persistent/.DeepOnion/DeepOnion-qt.desktop /usr/share/applications/DeepOnion-qt.desktop

### Overwrite the stock firewall rules to allow DeepOnion and restart firewall
sudo cp /home/amnesia/Persistent/.DeepOnion/ferm/ferm.conf /etc/ferm/ferm.conf
sudo ferm /etc/ferm/ferm.conf
