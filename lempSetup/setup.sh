#!/bin/bash

#Update packages
sudo apt update
sudo apt upgrade
sudo add-apt-repository universe

#Install packages
sudo apt install openssh-server
sudo apt install net-tools
sudo apt install nginx
sudo apt install mysql-server
sudo apt install php-fpm php-mysql

#Get required variables
hname=$(hostname)
phpversion=$(php -v | head -n 1 | awk '{split($0, a, " "); split(a[2], b, "."); printf "%s.%s\n",b[1],b[2]}')
scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
echo -n "Set mysql password for root: "; read rootpassword
echo -n "Set mysql password for php-user: "; read phppassword
echo -n "Set database name: "; read dbname

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

#Configure mysql
sudo mysql_secure_installation
sudo mysql -u root -e "
        alter user 'root'@'localhost' identified with mysql_native_password by '${rootpassword}';
        create user 'php'@'localhost' identified by '${phppassword}';
        create database ${dbname} character set utf8mb4 collate utf8mb4_bin;
        grant all privileges on ${dbname}.* to 'php'@'localhost';
        flush privileges;
"
#Place test php scripts
cat src/php/connect.php | sed -e "s/##DBNAME##/${dbname}/" | sed -e "s/##PHPPASSWORD##/${phppassword}/" > src/php/connect.php.tmp
sudo mv src/php/connect.php.tmp /var/www/html/connect.php
sudo cp src/php/index.php /var/www/html/index.php

#Perform tests
if [[ "$(curl --insecure https://localhost/test.php 2>/dev/null)" == '{"uri":"\/test.php"}' ]]; then
        echo 'Test 1 : OK : {"uri":"\/test.php"}'" obtained from https://localhost/test.php"
else
	echo "Test 1 : FAILED : expected response: "'{"uri":"\/test.php"}'
	echo "Actual response:"
	curl --insecure https://localhost/test.php
	echo -e "\n"
fi

if [[ "$(curl --insecure https://localhost/path/to/file 2>/dev/null)" == '{"uri":"\/path\/to\/file"}' ]]; then
	echo 'Test 2 : OK : {"uri":"\/path\/to\/file"} obtained from https://localhost/path/to/file'
else
	echo "Test 2 : FAILED : failed, expected response: "'{"uri":"\/path\/to\/file"}'
	curl --insecure https://localhost/path/to/file
fi
