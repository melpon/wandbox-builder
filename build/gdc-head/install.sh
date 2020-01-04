#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/gdc-head

# get sources

mkdir ~/gdc-head
cd ~/gdc-head

git clone --depth 1 https://github.com/gcc-mirror/gcc.git source

# build

mkdir build
cd build
../source/configure \
  --prefix=$PREFIX \
  --enable-languages=d \
  --disable-multilib \
  --without-ppl \
  --without-cloog-ppl \
  --enable-checking=release \
  --disable-nls \
  --enable-lto \
  LDFLAGS="-Wl,-rpath,$PREFIX/lib,-rpath,$PREFIX/lib64,-rpath,$PREFIX/lib32"

make -j`nproc`
rm -rf $PREFIX
make install
