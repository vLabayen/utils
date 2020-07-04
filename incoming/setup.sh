#!/bin/bash

#TODO : Get priority incoming times
#TODO : Store config in /etc/incoming/incoming.cfg
#TODO : Use config in the .bashrc code

scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
user=$(whoami)

sudo cp incoming /usr/bin/
sudo mkdir /etc/incoming
sudo touch /etc/incoming/incoming.csv
sudo chown ${user}:${user} /etc/incoming/incoming.csv

cat $scriptpath/src/bashrc.txt >> ~/.bashrc
