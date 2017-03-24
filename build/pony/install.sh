#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/pony-$VERSION

cd ~/

# get sources
wget_strict_sha256 \
  https://github.com/ponylang/ponyc/archive/$VERSION.tar.gz \
  $BASE_DIR/resources/$VERSION.tar.gz.sha256

tar xf $VERSION.tar.gz

# build
cd ponyc-$VERSION
make -j2
make prefix=$PREFIX install
