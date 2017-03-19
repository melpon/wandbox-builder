#!/bin/bash

. ../init.sh

BOOTSTRAP_VERSION=3.0.2
PREFIX=/opt/wandbox/fpc-head

# get bootstrap binary

cd ~/

wget_strict_sha256 \
  https://downloads.sourceforge.net/project/freepascal/Linux/$BOOTSTRAP_VERSION/fpc-$BOOTSTRAP_VERSION.x86_64-linux.tar \
  $BASE_DIR/resources/fpc-$BOOTSTRAP_VERSION.x86_64-linux.tar.sha256

tar xf fpc-$BOOTSTRAP_VERSION.x86_64-linux.tar
cd fpc-$BOOTSTRAP_VERSION.x86_64-linux
./install.sh < /dev/null
cd ..

# get sources

svn checkout http://svn.freepascal.org/svn/fpc/trunk fpc

# build

cd fpc
make build INSTALL_PREFIX=$PREFIX

rm -r $PREFIX || true
make install INSTALL_PREFIX=$PREFIX

cp $BASE_DIR/resources/run-fpc.sh.in $PREFIX/bin/run-fpc.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-fpc.sh
chmod +x $PREFIX/bin/run-fpc.sh

# make symlink

ln -sf /opt/wandbox/fpc-head/lib/fpc/*/ppcx64 /opt/wandbox/fpc-head/bin/ppcx64

rm -r ~/*
