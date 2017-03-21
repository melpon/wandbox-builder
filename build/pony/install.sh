#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/pony-$VERSION
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
wget_strict_sha256 \
  https://github.com/ponylang/ponyc/archive/$VERSION.tar.gz \
  $BASE_DIR/resources/$VERSION.tar.gz.sha256

tar xf $VERSION.tar.gz

# build
cd ponyc-$VERSION
make -j2
make prefix=$PREFIX install
