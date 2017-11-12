#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/luajit-head

# get sources

cd ~/

git clone https://luajit.org/git/luajit-2.0.git
cd luajit-2.0
git checkout v2.1

# build

make PREFIX=$PREFIX
rm -rf $PREFIX
make install PREFIX=$PREFIX

cd $PREFIX/bin
ln -sf luajit-* $PREFIX/bin/luajit

rm -r ~/*
