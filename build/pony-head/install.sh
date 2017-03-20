#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/pony-head

# get LLVM
wget_strict_sha256 \
  http://releases.llvm.org/3.9.1/clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
  $BASE_DIR/resources/clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz.sha256
tar xJf clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
  --strip-components 1 -C /usr/local/ clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04

# get sources
cd ~/
git clone --depth 1 https://github.com/ponylang/ponyc.git

cd ponyc
git submodule update --recursive --init

# build
make -j2
make prefix=$PREFIX install
