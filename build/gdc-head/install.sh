#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/gdc-head

# get GDC sources

mkdir ~/gdc-head
cd ~/gdc-head

git clone --depth 1 https://github.com/D-Programming-GDC/GDC.git gdc

# get GCC sources

git clone --depth 10000 https://github.com/gcc-mirror/gcc.git gcc
cd gcc

VERSION=`cut -d- -f3 < ../gdc/gcc.version`
BEFORE=`date "+%Y-%m-%d" -d "$VERSION next day"`
COMMIT=`TZ=UTC git log -n1 --pretty=tformat:%H --before=$BEFORE`
git reset --hard $COMMIT
cd ..

# setup

cd gdc
./setup-gcc.sh ../gcc
cd ..

# build

mkdir build
cd build
../gcc/configure \
  --prefix=$PREFIX \
  --enable-languages=d \
  --disable-bootstrap \
  --disable-multilib \
  --without-ppl \
  --without-cloog-ppl \
  --enable-checking=release \
  --disable-nls \
  --enable-lto \
  --with-bugurl="http://bugzilla.gdcproject.org" \
  --disable-libgomp \
  --disable-libmudflap \
  --disable-libquadmath \
  LDFLAGS="-Wl,-rpath,$PREFIX/lib,-rpath,$PREFIX/lib64,-rpath,$PREFIX/lib32"

make -j2
make install

test_gdc $PREFIX
