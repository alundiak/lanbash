#!/bin/bash

# Execute:
# su
# ./nodejs.sh

NODE_V="v0.10.24"

yum -y install gcc-c++ compat-gcc-32 compat-gcc-32-c++

cd /tmp/
wget "http://nodejs.org/dist/$NODE_V/node-$NODE_V.tar.gz"
tar zxf "node-$NODE_V.tar.gz"
cd "node-$NODE_V"
./configure && make && make install

npm install -g grunt-cli nodemon bower jasmine-node
