#!/bin/bash

source $(dirname $0)/oref0-bash-common-functions.sh || (echo "ERROR: Failed to run oref0-bash-common-functions.sh. Is oref0 correctly installed?"; exit 1)

usage "$@" <<EOT
Usage: $self

Downloads OpenAPS packages using pip, and dependencies using apt-get and npm.
This is normally invoked from openaps-install.sh.
EOT

# TODO: remove the `Acquire::ForceIPv4=true` once Debian's mirrors work reliably over IPv6
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

apt-get install -y sudo
apt-get update && sudo apt-get -y upgrade
apt-get install -y git python python-dev software-properties-common python-numpy python-pip watchdog strace tcpdump screen acpid vim locate jq lm-sensors || die "Couldn't install packages"

# install/upgrade to latest node 8 if neither node 8 nor node 10+ LTS are installed
if ! nodejs --version | grep -e 'v8\.' -e 'v1[02468]\.' ; then
        bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -" || die "Couldn't setup node 8"
        apt-get install -y nodejs || die "Couldn't install nodejs"
        ## You may also need development tools to build native addons:
        ##sudo apt-get install gcc g++ make
fi
pip install -U openaps || die "Couldn't install openaps toolkit"
pip install -U openaps-contrib || die "Couldn't install openaps-contrib"
openaps-install-udev-rules || die "Couldn't run openaps-install-udev-rules"
activate-global-python-argcomplete || die "Couldn't run activate-global-python-argcomplete"
npm install -g json oref0 || die "Couldn't install json and oref0"
echo openaps installed
openaps --version
