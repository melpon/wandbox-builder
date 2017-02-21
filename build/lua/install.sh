#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/lua-$VERSION

# get sources

cd ~/

wget_strict_sha256 \
  http://www.lua.org/ftp/lua-$VERSION.tar.gz \
  $BASE_DIR/resources/lua-$VERSION.tar.gz.sha256

tar xf lua-$VERSION.tar.gz
cd lua-$VERSION

# build

sed -i -e "s|^INSTALL_TOP=.*|INSTALL_TOP= $PREFIX|" Makefile

make linux
make install

test_lua $PREFIX

rm -r ~/*
