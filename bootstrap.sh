#!/bin/bash
##Written by: Adam Duston and Vincent Flesouras
#January 2016
#This is a script to bootstrap the process of getting a new Mac 
#ready for Development tasks @SLAC on the DevOps team.
##
# No point going any farther if we're not running correctly...
#!/bin/bash
BASEDIR=`dirname $0`
VIRTUALENVDIR="${BASEDIR}/ve"
​
if [ `id -u` != 0 ]; then
    echo "This script must be run as root."
    exit 1
fi
​
# Ensure pip is installed
if  [ ! -f /usr/local/bin/pip ]; then
    echo "Installing pip..."
    /usr/bin/easy_install pip
fi
​
# Install virtualenv if it's not installed already
if  [ ! -f /usr/local/bin/virtualenv ]; then
    echo "Installing virtualenv..."
    /usr/local/bin pip install virtualenv
fi
​
# Create a new virtualenv if one doesn't exist.
if [ ! -d $VIRTUALENVDIR ]; then
    echo "Creating Virtualenv..."
    /usr/local/bin/virtualenv $VIRTUALENVDIR
fi
​
# Install Battleschool
echo "Installing dependencies... "
$VIRTUALENVDIR/bin/pip install ansible==1.9.1
$VIRTUALENVDIR/bin/pip install Battleschool
​
if [ ! -d ~/.battleschool/playbooks ]; then
    mkdir -p ~/.battleschool/playbooks
fi
​
#Get the required configs
curl -OL https://github.com/SLAC-Lab/mac-dev-deployment/archive/master.zip
#expand archive
unzip master.zip -d ~/.battleschool/playbooks/
​
echo "Running custom configuration for SLAC"
$VIRTUALENVDIR/bin/battle --config-file ~/.battleschool/playbooks/mac-dev-deployment-master/config.yml
​
​
echo "Cleaning up..."
rm -rf $VIRTUALENVDIR
rm -f master.zip