#!/bin/bash

#TODO : Get priority incoming times
#TODO : Store config in /etc/incoming/incoming.cfg
#TODO : Use config in the .bashrc code

if [ ! -z "$1" ]; then
	scriptpath=$1
else
	scriptpath="/usr/bin/"
fi

thispath="$( cd "$(dirname "$0")" ; pwd -P )"
user=$(whoami)

sudo cp incoming $scriptpath
sudo chown ${user}:${user} $scriptpath/incoming
sudo chmod +xr $scriptpath/incoming
mkdir ~/.incoming
touch ~/.incoming/incoming.csv
cat $thispath/src/bashrc.txt >> ~/.bashrc
