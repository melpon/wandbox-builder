#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rill-head

eval `opam config env`

# llvm (only install)

cd /root/llvm-3.9.1.src/build && \
    cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -P cmake_install.cmake
cp /opt/llvm/bin/llc $PREFIX/bin/.
cp /opt/llvm/bin/llvm-config $PREFIX/bin/.


# rill-head

cd ~/
mkdir rill-head
cd rill-head

# get sources

git clone --depth 1 https://github.com/yutopp/rill.git

# build

cd rill
RILL_LLC_PATH=$PREFIX/bin/llc LIBRARY_PATH=$LIBRARY_PATH$PREFIX/lib \
             omake RELEASE=true PREFIX=$PREFIX
RILL_LLC_PATH=$PREFIX/bin/llc LIBRARY_PATH=$LIBRARY_PATH$PREFIX/lib \
             omake test
omake install

cd ~/
rm -r rill-head
