#!/bin/bash

set -ex

PREFIX=/opt/wandbox/gcc-head

apt-get update
apt-get install -y \
  bison \
  build-essential \
  coreutils \
  curl \
  flex \
  git \
  libgmp-dev \
  libmpc-dev \
  libmpfr-dev \
  libtool \
  m4 \
  unzip \
  wget

# get sources

mkdir ~/gcc-head
cd ~/gcc-head

git clone --depth 1 https://github.com/gcc-mirror/gcc.git source

# build

mkdir build
cd build
../source/configure \
  --prefix=$PREFIX \
  --enable-languages=c,c++ \
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
