#!/bin/bash

#TODO : get path to easycolor or install it

scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
user=$(whoami)

sudo cp remember /usr/bin/
sudo mkdir /etc/remember
sudo touch /etc/remember/remember.csv
sudo chown ${user}:${user} /etc/remember/remember.csv

cat $scriptpath/src/bashrc.txt >> ~/.bashrc
