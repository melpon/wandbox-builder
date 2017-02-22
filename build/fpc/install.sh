#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/fpc-$VERSION

# get bootstrap binary

cd ~/

wget_strict_sha256 \
  https://downloads.sourceforge.net/project/freepascal/Linux/$VERSION/fpc-$VERSION.x86_64-linux.tar \
  $BASE_DIR/resources/fpc-$VERSION.x86_64-linux.tar.sha256

tar xf fpc-$VERSION.x86_64-linux.tar
cd fpc-$VERSION.x86_64-linux
./install.sh < /dev/null
cd ..

# get sources

wget_strict_sha256 \
  https://downloads.sourceforge.net/project/freepascal/Source/$VERSION/fpc-$VERSION.source.tar.gz \
  $BASE_DIR/resources/fpc-$VERSION.source.tar.gz.sha256

tar xf fpc-$VERSION.source.tar.gz

# build

cd fpc-$VERSION
make build INSTALL_PREFIX=$PREFIX
make install INSTALL_PREFIX=$PREFIX

cp $BASE_DIR/resources/run-fpc.sh.in $PREFIX/bin/run-fpc.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-fpc.sh
chmod +x $PREFIX/bin/run-fpc.sh

# make symlink

ln -sf /opt/wandbox/fpc-$VERSION/lib/fpc/*/ppcx64 /opt/wandbox/fpc-$VERSION/bin/ppcx64

# tests

test_fpc $PREFIX

rm -r ~/*
