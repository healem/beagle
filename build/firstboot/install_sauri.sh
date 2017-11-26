#!/bin/bash

# Install pip
apt-get install -y python-pip
apt-get clean

# Install sauri
pip install sauri

# Copy over config file
mkdir -p /etc/sauri
cp /usr/local/lib/python2.7/dist-packages/sauri/cfg/home.yaml /etc/sauri/home.yaml
