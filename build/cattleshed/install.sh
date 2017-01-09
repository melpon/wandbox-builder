#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/cattleshed

# get sources

cd ~/
git clone --depth 1 https://github.com/melpon/wandbox

# build

cd wandbox/cattleshed
autoreconf -i
./configure --disable-install-setcap --prefix=$PREFIX

make -j2
make install
