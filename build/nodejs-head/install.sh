#!/bin/bash

. ./init.sh

VERSION=$1
PREFIX=/opt/wandbox/nodejs-head

# get sources

cd ~/
git clone --depth 1 https://github.com/nodejs/node.git
cd node

# build

./configure --prefix=$PREFIX --partly-static
make -j2
make install

# update

PATH=$PREFIX/bin:$PATH npm update -g

test_nodejs $PREFIX
