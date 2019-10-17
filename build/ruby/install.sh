#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://cache.ruby-lang.org/pub/ruby/"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ruby-$VERSION
SHORT_VERSION=$(echo "$VERSION" | sed -e 's/^\([0-9]\.[0-9]\).*$/\1/')

# get sources

cd ~/
wget_strict_sha256 \
  https://cache.ruby-lang.org/pub/ruby/$SHORT_VERSION/ruby-$VERSION.tar.gz \
  $BASE_DIR/resources/ruby-$VERSION.tar.gz.sha256
tar xf ruby-$VERSION.tar.gz
cd ruby-$VERSION

# build

./configure --disable-install-rdoc --disable-install-doc --prefix=$PREFIX
make -j2
make install

rm -r ~/*
