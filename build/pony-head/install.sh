#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/pony-head

cd ~/

# get sources
git clone --depth 1 https://github.com/ponylang/ponyc.git

cd ponyc
git submodule update --recursive --init

# build
make -j2
make prefix=$PREFIX install
