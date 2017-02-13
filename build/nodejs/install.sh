#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/nodejs-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://nodejs.org/dist/v$VERSION/node-v$VERSION.tar.gz \
  $BASE_DIR/resources/node-v$VERSION.tar.gz.sha256

tar xf node-v$VERSION.tar.gz
cd node-v$VERSION

# build

./configure --prefix=$PREFIX --partly-static
make -j2
make install

# update

PATH=$PREFIX/bin:$PATH npm update -g

test_nodejs $PREFIX
