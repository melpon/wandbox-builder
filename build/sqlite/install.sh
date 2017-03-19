#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/sqlite-$VERSION

# get sources

case "$VERSION" in
  "3.8.1" ) YEAR=2013; NUMVER=3080100 ;;
  "3.17.0" ) YEAR=2017; NUMVER=3170000 ;;
  * ) exit 1
esac

cd ~/

wget_strict_sha256 \
  http://www.sqlite.org/$YEAR/sqlite-autoconf-$NUMVER.tar.gz \
  $BASE_DIR/resources/sqlite-autoconf-$NUMVER.tar.gz.sha256

tar xf sqlite-autoconf-$NUMVER.tar.gz
cd sqlite-autoconf-$NUMVER

# build

./configure --prefix=$PREFIX
make -j2
make install

rm -r ~/*
