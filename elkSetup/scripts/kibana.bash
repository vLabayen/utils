#!/bin/bash

if [ "$#" != "2" ]; then
	echo "Usage: kibana.bash <listen_addr> <listen_port>" 1>&2
	exit 1
fi
listen_addr=$1
listen_port=$2

# Install kibana
sudo apt install kibana

# Configure kibana
sudo sed -i "s|#server.host: \"localhost\"|server.host: \"${listen_addr}\"|g" /etc/kibana/kibana.yml
sudo sed -i "s|#server.port: 5601|server.port: ${listen_port}|g" /etc/kibana/kibana.yml
sudo service kibana restart
