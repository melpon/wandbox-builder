#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/php-$VERSION

# get sources

cd ~/

wget_strict_sha256 \
  http://php.net/get/php-$VERSION.tar.gz/from/this/mirror \
  $BASE_DIR/resources/php-$VERSION.tar.gz.sha256 \
  -O php-$VERSION.tar.gz

tar xf php-$VERSION.tar.gz
cd php-$VERSION

# build

./configure --prefix=$PREFIX --disable-libxml --disable-dom --disable-simplexml --disable-xml --disable-xmlreader --disable-xmlwriter --without-pear

make -j2
make install

test_php $PREFIX

rm -r ~/*
