#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/kennel

# get sources

cd ~/
git clone --depth 1 https://github.com/melpon/wandbox

# build kennel
cd wandbox/kennel2
git submodule update -i
./autogen.sh
./configure --prefix=/opt/wandbox/kennel --with-cppcms=/usr/local/cppcms --with-cppdb=/usr/local/cppdb
make
make install
