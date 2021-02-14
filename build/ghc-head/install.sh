#!/bin/bash

. ../init.sh

# haskell stack install
wget -qO- https://get.haskellstack.org/ | sh
stack setup
# configure: error: Alex version 3.2.5 or earlier is required to compile GHC. See GHC issue 19099 for more information.
stack install alex-3.2.5
stack install happy
export PATH=/root/.local/bin:$PATH
COMPILER_BIN=`stack path --compiler-bin`

PREFIX=/opt/wandbox/ghc-head

# get sources

cd ~/
git clone --recursive https://gitlab.haskell.org/ghc/ghc.git

# install

cd ghc
cp mk/build.mk.sample mk/build.mk
sed -i 's/#BuildFlavour = devel2/BuildFlavour = devel2/' mk/build.mk
./boot
./configure --prefix=$PREFIX GHC="${COMPILER_BIN}/ghc"
make # -j2 <- insufficient memory
rm -r $PREFIX/* || true
make install
rm -r $PREFIX/share

# cleanup

cd ~/
rm -r ~/*
