#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/dmd-$VERSION

# get sources

cd ~/

wget_strict_sha256 \
  http://downloads.dlang.org/releases/2.x/$VERSION/dmd.$VERSION.linux.tar.xz \
  $BASE_DIR/resources/dmd.$VERSION.linux.tar.xz.sha256
tar xf dmd.$VERSION.linux.tar.xz

# install

rm -r $PREFIX || true
cp -r dmd2 $PREFIX

# cleanup

cd ~/
rm -r ~/*
