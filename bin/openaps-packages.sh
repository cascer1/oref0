#!/usr/bin/env bash

source $(dirname $0)/oref0-bash-common-functions.sh || (echo "ERROR: Failed to run oref0-bash-common-functions.sh. Is oref0 correctly installed?"; exit 1)

usage "$@" <<EOT
Usage: $self

Downloads OpenAPS packages using pip, and dependencies using apt-get and npm.
This is normally invoked from openaps-install.sh.
EOT

# TODO: remove the `Acquire::ForceIPv4=true` once Debian's mirrors work reliably over IPv6
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

echo 'INSTALLING SUDO'
apt-get install -y sudo
echo 'DOING APT-GET UPDATE & UPGRADE'
sudo apt-get update && sudo apt-get -y upgrade
echo 'INSTALLING   [git, python, python-dev, software-properties-common, python-numpy, python-pip, watchdog, strace, tcpdump, screen, acpid, vim, locate, jq, lm-sensors'
sudo apt-get install -y git python python-dev software-properties-common python-numpy python-pip watchdog strace tcpdump screen acpid vim locate jq lm-sensors || die "Couldn't install packages"

echo 'CHECKING NODE INSTALLATION'
# install/upgrade to latest node 8 if neither node 8 nor node 10+ LTS are installed
if ! nodejs --version | grep -e 'v8\.' -e 'v1[02468]\.' ; then
        echo 'INSTALLING NODE'
        sudo bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -" || die "Couldn't setup node 8"
        sudo apt-get install -y nodejs || die "Couldn't install nodejs"
        ## You may also need development tools to build native addons:
        ##sudo apt-get install gcc g++ make
fi

echo 'INSTALLING NPM'
apt-get install -y npm

echo 'PIP INSTALLING OPENAPS'
sudo pip install -U openaps || die "Couldn't install openaps toolkit"
sudo pip install -U openaps-contrib || die "Couldn't install openaps-contrib"
sudo openaps-install-udev-rules || die "Couldn't run openaps-install-udev-rules"
sudo activate-global-python-argcomplete || die "Couldn't run activate-global-python-argcomplete"

echo 'NPM INSTALLING OREF0'
sudo npm install -g json oref0 || die "Couldn't install json and oref0"
echo openaps installed
openaps --version
