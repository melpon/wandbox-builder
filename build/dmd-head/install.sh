#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/dmd-head

# get sources

mkdir ~/dmd-head
cd ~/dmd-head

git clone --depth 1 https://github.com/dlang/dmd
git clone --depth 1 https://github.com/dlang/druntime
git clone --depth 1 https://github.com/dlang/phobos

# build

cd dmd
make -j2 -f posix.mak AUTO_BOOTSTRAP=1
make -f posix.mak install AUTO_BOOTSTRAP=1
cd ..

cd druntime
make -j2 -f posix.mak
make -f posix.mak install
cd ..

cd phobos
make -j2 -f posix.mak
make -f posix.mak install
cd ..

# install

rm -r $PREFIX || true
cp -r ~/dmd-head/install $PREFIX
