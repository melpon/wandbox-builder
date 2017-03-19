#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/php-head

# get sources

cd ~/

git clone --depth 1 https://github.com/php/php-src.git
cd php-src

# build

./buildconf
./configure --prefix=$PREFIX --disable-libxml --disable-dom --disable-simplexml --disable-xml --disable-xmlreader --disable-xmlwriter --without-pear --disable-phar

make -j2
make install

rm -r ~/*
