#!/bin/bash
##Written by: Adam Duston and Vincent Flesouras
#January 2016
#This is a script to bootstrap the process of getting a new Mac 
#ready for Development tasks @SLAC on the DevOps team.
##
# No point going any farther if we're not running correctly...
if [ `whoami` != 'root' -a "$1" -a "$1" != "--list" ]; then
  read -d '' prompt <<- EOT
bootstrap.sh requires super-user privileges to work.
Enter your password to continue...
Password:
EOT

  sudo -E -p "$prompt" "$0" $* || exit 1
  exit 0
fi

if [ "$SUDO_USER" = "root" -a "$1" -a "$1" != "--list" ]; then
  /bin/echo "You must start this under your regular user account (not root) using sudo."
  /bin/echo "Rerun using: sudo $0 $*"
  exit 1
fi

BASEDIR=`dirname $0`
VIRTUALENVDIR="${BASEDIR}/temp_virtual_env"

mkdir ~/temp_virtual_env


# Ensure pip is installed
if  [ ! -f /usr/local/bin/pip ]; then
    echo "Installing pip..." 
    sudo easy-install pip
fi


# Install BattleSchool
echo "Installing BattleSchool, the ansible wrapper... "
sudo pip install BattleSchool
mkdir ~/.battleschool/playbooks
#Get the required configs
cd ~/.battleschool/playbooks/
curl -O https://github.com/SLAC-Lab/mac-dev-deployment/archive/master.zip 
#expand archive
unzip ~/.battleschool/playbooks/master.zip -d ~/.battleschool/playbooks/

echo "Running custom configuration for SLAC"
battle --config-file ~/.battleschool/playbooks/mac-dev-deployment-master/config.yml