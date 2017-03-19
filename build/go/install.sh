#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/go-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://github.com/golang/go/archive/go$VERSION.tar.gz \
  $BASE_DIR/resources/go$VERSION.tar.gz.sha256

tar xf go$VERSION.tar.gz

rm -rf $PREFIX || true
mv go-go$VERSION $PREFIX

# build

cd $PREFIX/src

./make.bash
