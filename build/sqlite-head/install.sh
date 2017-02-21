#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/sqlite-head

# get sources

cd ~/

USER=wandbox-builder fossil clone https://www.sqlite.org/cgi/src sqlite.fossil
mkdir source
cd source
fossil open ../sqlite.fossil
cd ..

# build

mkdir build
cd build
../source/configure --prefix=$PREFIX --disable-tcl --disable-readline --disable-load-extension

make -j2
make install

test_sqlite $PREFIX

rm -r ~/*
