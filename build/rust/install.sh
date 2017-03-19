#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/rust-$VERSION

# get sources

cd ~/

git clone --depth 1 --branch $VERSION https://github.com/rust-lang/rust.git

cd rust

# apply patch

# build

./configure --prefix=$PREFIX
make -j2
make install

rm -r ~/*
