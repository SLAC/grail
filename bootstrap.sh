#!/bin/bash
##Written by: Adam Duston and Vincent Flesouras
#January 2016
#This is a script to bootstrap the process of getting a new Mac 
#ready for Development tasks @SLAC on the DevOps team.
##
# No point going any farther if we're not running correctly...
#!/bin/bash
BASEDIR=`dirname $0`
WORKINGDIR=~/.battleschool/playbooks
VIRTUALENVDIR="${WORKINGDIR}/ve"
MYUSER = stat -f '%u %Su' /dev/console | /usr/bin/awk '{print $2}'
print MYUSER
if [[ `id -u` != 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi


if [[ ! -d $WORKINGDIR ]]; then
    mkdir -p ~/.battleschool/playbooks
fi

#Get the required configs
if [[! -d $WORKINGDIR/playbooks/mac-dev-deployment ]]; then
echo "Getting the correct configs/n"
curl -OL https://github.com/SLAC-Lab/mac-dev-deployment/archive/master.zip

#expand archive
echo "Expanding..../n"
unzip master.zip -d $WORKINGDIR
fi

cp $WORKINGDIR/mac-dev-deployment/* $WORKINGDIR/* 

#install x-code, it is necessary for the rest of it.
sh $WORKINGDIR/install-xcode.sh

# Ensure pip is installed
if  [[ ! -f /usr/local/bin/pip ]]; then
    echo "Installing pip..."
    /usr/bin/easy_install pip
fi

# Install Battleschool
echo "Installing dependencies... "
/usr/local/bin/pip install ansible==1.9.1
/usr/local/bin/pip install Battleschool

echo "Running custom configuration for SLAC"
battle --config-file $WORKINGDIR/config.yml --become-user="$MY_USER"

echo "Cleaning up..."
rm -f master.zip


