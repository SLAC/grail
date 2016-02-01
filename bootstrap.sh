#!/bin/bash
##Written by: Adam Duston and Vincent Flesouras
#January 2016
#This is a script to bootstrap the process of getting a new Mac 
#ready for Development tasks @SLAC on the DevOps team.
##
##
BASEDIR=`dirname $0`
WORKINGDIR=~/.battleschool/playbooks
#myuser=$3  if we use casper
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osxprep.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Step 1: Update the OS and Install Xcode Tools
echo "------------------------------"
echo "Updating OSX.  If this requires a restart, run the script again."
# Install all available updates
#sudo softwareupdate -iva
# Install only recommended available updates
sudo softwareupdate -irv

echo "------------------------------"
echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install
#sleep for three minutes 
sleep 3m
# Download and install Homebrew
echo "Installing Homebrew"
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    echo "--As user-- $(logname)" 
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

fi

echo "------------------------------"
echo "Installing expanded Homebrew repos."
# Install Cask
brew install caskroom/cask/brew-cask
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
brew install git-extras


# Modify the PATH
export PATH=/usr/local/bin:$PATH

#create the directory we want to work out of
#TODO implment virtualenv

if [[ ! -d $WORKINGDIR ]]; then
    mkdir -p ~/.battleschool/playbooks
fi

Get the required configs
if [[ ! -d $WORKINGDIR/mac-dev-deployment ]]; then
	echo "Getting the correct configs/n"
	curl -OL https://github.com/SLAC-Lab/mac-dev-deployment/archive/master.zip

	#expand archive
	echo "Expanding..../n"
	unzip master.zip -d $WORKINGDIR
fi

cp -R $WORKINGDIR/mac-dev-deployment-master/ $WORKINGDIR/ 

# Ensure pip is installed
if  [[ ! -f /usr/local/bin/pip ]]; then
    echo "Installing pip..."
  sudo /usr/bin/easy_install pip
fi

#update sudo's timestamp, as we want it after the long install above
sudo -v

# Install Battleschool
echo "Installing dependencies... "
sudo /usr/local/bin/pip install ansible==1.9.1
sudo /usr/local/bin/pip install Battleschool

echo "Running custom configuration for SLAC"
sudo battle --config-file $WORKINGDIR/config.yml


sudo -v #again with the keepalive
echo "Cleaning up..."
rm -f master.zip
rm -Rf $WORKINGDIR/mac-dev-deployment

echo "All Done!  Happy Coding!"

