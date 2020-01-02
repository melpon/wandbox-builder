#!/bin/bash

set -ex

apt-get update
apt-get install -y \
  build-essential \
  coreutils \
  clang \
  libc6-dev-i386 \
  libgmp-dev \
  libmpc-dev \
  libmpfr-dev \
  libstdc++-5-dev \
  libtool \
  python \
  wget

CMAKE_VERSION="3.7.1"
CMAKE_SHA256="43cc57605a4f0a3789c463052f66dec3bcce987d204c1aa9b1a9ca5175fad256"

CMAKE_PREFIX="/usr/local/wandbox/camke-${CMAKE_VERSION}"

wget https://github.com/Kitware/CMake/archive/v${CMAKE_VERSION}.tar.gz
echo "${CMAKE_SHA256} *v${CMAKE_VERSION}.tar.gz" | sha256sum -c
tar xf v${CMAKE_VERSION}.tar.gz
cd CMake-${CMAKE_VERSION}
./configure --prefix=$CMAKE_PREFIX
make -j`nproc`
make install

./install.sh
