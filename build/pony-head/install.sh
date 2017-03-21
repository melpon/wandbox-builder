#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/pony-head
LLVM_VERSION=3.9.1

cd ~/

# install prebuilt LLVM
wget_strict_sha256 \
  "http://releases.llvm.org/${LLVM_VERSION}/clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-16.04.tar.xz" \
  "$BASE_DIR/resources/clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-16.04.tar.xz.sha256"
tar xJf "clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-16.04.tar.xz" \
  --strip-components 1 \
  -C /usr/local/ \
  "clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-16.04"

# get sources
git clone --depth 1 https://github.com/ponylang/ponyc.git

cd ponyc
git submodule update --recursive --init

# build
make -j2
make prefix=$PREFIX install
