#!/bin/bash

#Update packages
sudo apt update
sudo apt upgrade
sudo add-apt-repository universe

#Install packages
sudo apt install net-tools
sudo apt install nginx
sudo apt install php-fpm

#Get required variables
hname=$(hostname)
phpversion=$(php -v | head -n 1 | awk '{split($0, a, " "); split(a[2], b, "."); printf "%s.%s\n",b[1],b[2]}')

#Configure ssh
ssh-keygen
sudo cp src/sshd_config /etc/ssh/sshd_config
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo service sshd restart

#Configure nginx
cat src/nginx_default | sed -e "s/##SERVERNAME##/${hname}/" | sed -e "s/##PHPVERSION##/${phpversion}/" > src/nginx_default.tmp
sudo mv src/nginx_default.tmp /etc/nginx/sites-available/default
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/${hname}_nginx.key -out /etc/ssl/certs/${hname}_nginx.crt -config src/crt.conf
sudo systemctl reload nginx

#Configure php
sed -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' /etc/php/$phpversion/fpm/php.ini > src/php.ini.tmp
sudo mv src/php.ini.tmp /etc/php/$phpversion/fpm/php.ini
sudo systemctl restart php${phpversion}-fpm

#Set test script
sudo cp src/php/index.php /var/www/html/index.php
