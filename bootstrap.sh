#!/usr/bin/env bash
#!/bin/bash

BGreen='\e[1;32m'       # Green
BRed='\e[1;31m'         # Red
Color_Off='\e[0m'       # Text Reset
BASEDIR=`dirname $0`
WORKINGDIR=~/.slac-mac
ROLESDIR=~/roles

function setStatusMessage {
    printf "${IRed} --> ${BGreen}$1${Color_Off}\n" 1>&2
}

printf "${BRed}    _____ _               _____      ____   _____ _____ ____  ${Color_Off}\n"
printf "${BRed}   / ____| |        /\   / ____|    / __ \ / ____|_   _/ __ \ ${Color_Off}\n"
printf "${BRed}  | (___ | |       /  \ | |        | |  | | |      | || |  | |${Color_Off}\n"
printf "${BRed}   \___ \| |      / /\ \| |        | |  | | |      | || |  | |${Color_Off}\n"
printf "${BRed}   ____) | |____ / ____ \ |____    | |__| | |____ _| || |__| |${Color_Off}\n"
printf "${BRed}  |_____/|______/_/    \_\_____|    \____/ \_____|_____\____/ ${Color_Off}\n\n"

setStatusMessage "Checking if we need to ask for a sudo password"

sudo -v
export ANSIBLE_ASK_SUDO_PASS=True

username=all
if [ ! -z "$1" ]; then
    profile=$1
fi


function triggerError {
    printf "${BRed} --> $1 ${Color_Off}\n" 1>&2
    exit 1
}

# Check whether a command exists - returns 0 if it does, 1 if it does not
function exists {
  if command -v $1 >/dev/null 2>&1
  then
    return 0
  else
    return 1
  fi
}

# credits https://github.com/boxcutter/osx/blob/master/script/xcode-cli-tools.sh
function install_clt {
    # Get and install Xcode CLI tools
    OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')

    # on 10.9+, we can leverage SUS to get the latest CLI tools
    if [ "$OSX_VERS" -ge 9 ]; then
        # create the placeholder file that's checked by CLI updates' .dist code
        # in Apple's SUS catalog
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        # find the CLI Tools update
        PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
        # install it
        softwareupdate -i "$PROD" -v
        rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    # on 10.7/10.8, we instead download from public download URLs, which can be found in
    # the dvtdownloadableindex:
    # https://devimages.apple.com.edgekey.net/downloads/xcode/simulators/index-3905972D-B609-49CE-8D06-51ADC78E07BC.dvtdownloadableindex
    else
        [ "$OSX_VERS" -eq 7 ] && DMGURL=http://devimages.apple.com.edgekey.net/downloads/xcode/command_line_tools_for_xcode_os_x_lion_april_2013.dmg
        [ "$OSX_VERS" -eq 7 ] && ALLOW_UNTRUSTED=-allowUntrusted
        [ "$OSX_VERS" -eq 8 ] && DMGURL=http://devimages.apple.com.edgekey.net/downloads/xcode/command_line_tools_for_osx_mountain_lion_april_2014.dmg

        TOOLS=clitools.dmg
        curl "$DMGURL" -o "$TOOLS"
        TMPMOUNT=`/usr/bin/mktemp -d /tmp/clitools.XXXX`
        hdiutil attach "$TOOLS" -mountpoint "$TMPMOUNT"
        installer $ALLOW_UNTRUSTED -pkg "$(find $TMPMOUNT -name '*.mpkg')" -target /
        hdiutil detach "$TMPMOUNT"
        rm -rf "$TMPMOUNT"
        rm "$TOOLS"
        exit
    fi
}

setStatusMessage "Keep-alive: update existing sudo time stamp until we are finished"

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo -H pip install --upgrade setuptools --user python

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

if [[ ! -f "/Library/Developer/CommandLineTools/usr/bin/clang" ]]; then
    setStatusMessage "Install the CLT"
    install_clt
fi
#Install Brew here, because pip and setuptools needs it
if [[ ! -f "/usr/local/bin/brew" ]]; then
    setStatusMessage "Install Brew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#install python through brew
setStatusMessage "Install Python"
brew install python

#Install andible from src
setStatusMessage "Clone Ansible"
git clone git://github.com/ansible/ansible.git --recursive

#Prep envirtonment
setStatusMessage "Source config"
source ~/hacking/env-setup

#Install Pip
setStatusMessage "Install pip"
sudo easy_install pip

#install Ansible Support libs
setStatusMessage "Install paramiko, PyYAML, Jinja2, httplib2, six and virtualenv "
sudo pip install paramiko PyYAML Jinja2 httplib2 six virtualenv



#if ! exists MySQL-python; then
 #   setStatusMessage "Install MySQL-Python"
  #  sudo pip install -q MySQL-python
#fi

#if ! exists gitpython; then
 #   setStatusMessage "Install Git-Python"
 #   sudo pip install -q gitpython
#fi

#if ! exists pygithub; then
#    setStatusMessage "Install Python-Github"
#    sudo pip install -q pygithub
#fi

setStatusMessage "Get SLAC configs"
#Get the required configs
#blow away our folder, because we want to get fresh each time
rm -Rf ~/.slac-mac
git clone -q https://github.com/slac-ocio/grail ~/.slac-mac/


setStatusMessage "Create necessary local folders"
#these folders are necessary for grail. See Github wiki for structure
sudo mkdir -p /usr/local/grail
sudo mkdir -p /usr/local/grail/roles
sudo chmod -R g+rwx /usr/local
sudo chgrp -R admin /usr/local

if [ -d "/usr/local/grail/config" ]; then
    setStatusMessage "Welcome back, we'll Update your config from git"
    rm -Rf /usr/local/grail/config
    git clone -q https://github.com/slac-ocio/grail-config.git /usr/local/grail/config

else
    setStatusMessage "Getting your config from Github"
    git clone -q https://github.com/slac-ocio/grail-config.git /usr/local/grail/config

fi

cd /usr/local/grail

#Cheating and using Ansibles' hacking script
PREFIX_PYTHONPATH="/usr/local/bin/Cellar/bin/python2.7"

export PYTHONPATH="$PYTHONPATH"
export PATH="$PYTHONPATH:$PATH"


setStatusMessage "Create ansible.cfg"

{ echo '[defaults]'; echo 'roles_path=/usr/local/grail/roles:/usr/local/grail/config/roles'; } > ansible.cfg

alias python='/usr/local/Cellar/python'

setStatusMessage "Get all the required roles"

ansible-galaxy install -f -r config/requirements.yml -p roles

if [ -f "config/$profile.yml" ]; then
    setStatusMessage "Running the ansible playbook for $profile"
    ansible-playbook -i "localhost," config/$profile.yml 
else
    if [ "travis" = "$profile" ]; then
        setStatusMessage "Running the ansible playbook for $profile but use admin.yml as fallback"
        ansible-playbook -i "localhost," config/admin.yml
    else
        triggerError "No playbook for $profile found"
    fi
fi

