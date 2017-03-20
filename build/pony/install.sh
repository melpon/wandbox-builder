#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/pony-$VERSION

cd ~/

# get LLVM
wget_strict_sha256 \
  http://releases.llvm.org/3.9.1/clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
  $BASE_DIR/resources/clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz.sha256
tar xJf clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
  --strip-components 1 -C /usr/local/ clang+llvm-3.9.1-x86_64-linux-gnu-ubuntu-16.04

# get sources
wget_strict_sha256 \
  https://github.com/ponylang/ponyc/archive/$VERSION.tar.gz \
  $BASE_DIR/resources/$VERSION.tar.gz.sha256

tar xf $VERSION.tar.gz

# build
cd ponyc-$VERSION
make -j2
make prefix=$PREFIX install
