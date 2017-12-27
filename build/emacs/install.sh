#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/emacs-$VERSION

# get sources

cd ~/

wget_strict_sha256 \
  http://ftp.jaist.ac.jp/pub/GNU/emacs/emacs-$VERSION.tar.gz \
  $BASE_DIR/resources/emacs-$VERSION.tar.gz.sha256

tar -xf emacs-$VERSION.tar.gz
cd emacs-$VERSION

# build

env CANNOT_DUMP=yes ./configure --prefix=$PREFIX --without-x --without-sound

make
make install

rm -r ~/*
