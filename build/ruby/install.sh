#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://cache.ruby-lang.org/pub/ruby/"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ruby-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://cache.ruby-lang.org/pub/ruby/ruby-$VERSION.tar.gz \
  $BASE_DIR/resources/ruby-$VERSION.tar.gz.sha256
tar xf ruby-$VERSION.tar.gz
cd ruby-$VERSION

# build

./configure --disable-install-rdoc --disable-install-doc --prefix=$PREFIX
make -j2
make install

rm -r ~/*
