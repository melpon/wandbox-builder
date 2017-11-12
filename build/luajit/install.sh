#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/luajit-$VERSION

# get sources

cd ~/

wget_strict_sha256 \
  http://luajit.org/download/LuaJIT-$VERSION.tar.gz \
  $BASE_DIR/resources/LuaJIT-$VERSION.tar.gz.sha256

tar xf LuaJIT-$VERSION.tar.gz
cd LuaJIT-$VERSION

# build

make PREFIX=$PREFIX
make install PREFIX=$PREFIX

rm -r ~/*
