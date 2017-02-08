#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/ruby-head

# get sources

cd ~/
git clone --depth 1 https://github.com/ruby/ruby.git
cd ruby

# build

autoconf
./configure --disable-install-rdoc --disable-install-doc --prefix=$PREFIX
make -j2
make install

test_ruby $PREFIX

rm -r ~/*
