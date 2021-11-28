#!/bin/bash

if [ "$#" != 1 ]; then
	echo "Usage: elastic.bash <jvm_heap>" 1>&2
	echo "  jvm_heap: Heap size (RAM) of elastic's jvm. Ex: 2g, 1g, 512m, 256m" 1>&2
	exit 1
fi
jvm_heap=$1

# Install elastic
sudo apt install elasticsearch

# Configure elastic
sudo sed -i "s|## -Xms4g|-Xms${jvm_heap}|g" /etc/elasticsearch/jvm.options
sudo sed -i "s|## -Xmx4g|-Xmx${jvm_heap}|g" /etc/elasticsearch/jvm.options
sudo service elasticsearch restart
