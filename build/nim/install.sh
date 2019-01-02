#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <version>"
  exit 0
fi

. ../init.sh

VERSION=$1
PREFIX=/opt/wandbox/nim-$VERSION

# ==== get sources ====
cd ~/
wget_strict_sha256 \
  https://github.com/nim-lang/Nim/archive/v$VERSION.tar.gz \
  $BASE_DIR/resources/Nim-$VERSION.tar.gz.sha256 \
  -O Nim-$VERSION.tar.gz

mkdir -p ~/Nim-$VERSION && cd $_
tar xf ~/Nim-$VERSION.tar.gz --strip-component 1


if compare_version "$VERSION" ">=" "0.19.2"; then
  # ==== build ====
  cd ~/Nim-$VERSION
  sh build_all.sh
else
  # ==== get sources of bootstrap compiler ====
  cd ~/
  wget_strict_sha256 \
    https://github.com/nim-lang/csources/archive/v$VERSION.tar.gz \
    $BASE_DIR/resources/csources-$VERSION.tar.gz.sha256 \
    -O csources-$VERSION.tar.gz

  mkdir -p ~/Nim-$VERSION/csources && cd $_
  tar xf ~/csources-$VERSION.tar.gz --strip-component 1


  # ==== build ====
  cd ~/Nim-$VERSION
  # build bootstrap compiler
  cd csources
  sh ./build.sh
  # build bootstrap tool
  cd ..
  ./bin/nim c koch
  # compile Nim
  ./koch boot -d:release
fi

# ==== install ====
./koch install /opt
mv /opt/nim "$PREFIX"
