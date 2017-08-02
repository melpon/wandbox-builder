#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ghc-head
WITH_GHC=/opt/wandbox/ghc-8.0.2/bin/ghc

# get sources

cd ~/
git clone --recursive git://git.haskell.org/ghc.git

# install

cd ghc
cp mk/build.mk.sample mk/build.mk
sed -i 's/#BuildFlavour = devel2/BuildFlavour = devel2/' mk/build.mk
./boot
./configure --prefix=$PREFIX --with-ghc=$WITH_GHC
make # -j2 <- insufficient memory
rm -r $PREFIX/*
make install
rm -r $PREFIX/share

# cleanup

cd ~/
rm -r ~/*
