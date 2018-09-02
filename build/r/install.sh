#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/r-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://cran.r-project.org/src/base/R-3/R-$VERSION.tar.gz \
  $BASE_DIR/resources/R-$VERSION.tar.gz.sha256

tar xf R-$VERSION.tar.gz
cd R-$VERSION

# build

./configure --prefix=$PREFIX --without-readline --without-x

make -j2
make install

rm -r ~/*
