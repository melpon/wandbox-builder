#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://github.com/mruby/mruby/releases"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/mruby-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://github.com/mruby/mruby/archive/$VERSION.tar.gz \
  $BASE_DIR/resources/$VERSION.tar.gz.sha256
tar xf $VERSION.tar.gz
cd mruby-$VERSION

# build

./minirake
mkdir $PREFIX || true
cp -r bin $PREFIX

rm -r ~/*
