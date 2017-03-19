#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ghc-head

# get sources

cd ~/
git clone --recursive git://git.haskell.org/ghc.git

# install

cd ghc
./boot
./configure --prefix=$PREFIX # --with-ghc=...
cp mk/build.mk.sample mk/build.mk
sed -i 's/#BuildFlavour = devel2/BuildFlavour = devel2/' mk/build.mk
make
rm -r $PREFIX/*
make install
rm -r $PREFIX/share

# cleanup

cd ~/
rm -r ~/*
