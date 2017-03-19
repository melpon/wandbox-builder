#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/gcc-$VERSION

if compare_version "$VERSION" ">=" "4.7.3"; then
  FLAGS="--enable-lto"
else
  FLAGS=""
fi

if compare_version "$VERSION" "<=" "4.4.7"; then
  export CFLAGS="-fgnu89-inline"
  export CXXFLAGS="-fgnu89-inline"
fi

# get sources

mkdir -p ~/tmp/gcc-$VERSION/
cd ~/tmp/gcc-$VERSION/
wget_strict_sha256 \
  http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.gz \
  $BASE_DIR/resources/gcc-$VERSION.tar.gz.sha256

tar xf gcc-$VERSION.tar.gz
cd gcc-$VERSION

# apply patch

if compare_version "$VERSION" "<=" "4.5.4"; then
  patch -p1 -i $BASE_DIR/resources/gcc-$VERSION-multiarch.patch
fi

if compare_version "$VERSION" ">=" "4.7.0"; then
  if compare_version "$VERSION" "<=" "4.7.4"; then
    # https://github.com/DragonFlyBSD/DPorts/issues/136
    patch -p0 -i $BASE_DIR/resources/gcc-4.7.x-gcc_cp_cfns.patch
  fi
fi

# build

cd ..

mkdir build
cd build
../gcc-$VERSION/configure \
  --prefix=$PREFIX \
  --enable-languages=c,c++ \
  --disable-multilib \
  --without-ppl \
  --without-cloog-ppl \
  --enable-checking=release \
  --disable-nls \
  LDFLAGS="-Wl,-rpath,$PREFIX/lib,-rpath,$PREFIX/lib64,-rpath,$PREFIX/lib32" \
  $FLAGS

if compare_version "$VERSION" "<=" "4.4.7"; then
  sed -i -e "s/CC = gcc/CC = gcc -fgnu89-inline/" Makefile
  sed -i -e "s/CXX = g++/CXX = g++ -fgnu89-inline/" Makefile
fi

make -j2
make install
