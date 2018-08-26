#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/gdc-head

mkdir ~/gdc-head
cd ~/gdc-head


# gdc needs bootstrap: https://stackoverflow.com/questions/51815286/gdc-installation-error

# ---- step1 - build gdc on stable branch ----

# get GDC sources

git clone --depth 1 -b stable https://github.com/D-Programming-GDC/GDC.git gdc-stable

# get GCC sources

git clone --depth 10000 https://github.com/gcc-mirror/gcc.git gcc-stable
cd gcc-stable

VERSION=`cut -d- -f3 < ../gdc-stable/gcc.version`
BEFORE=`date "+%Y-%m-%d" -d "$VERSION next day"`
COMMIT=`TZ=UTC git log -n1 --pretty=tformat:%H --before=$BEFORE`
git reset --hard $COMMIT
cd ..

# setup

cd gdc-stable
./setup-gcc.sh ../gcc-stable
cd ..

# build

mkdir build
cd build
../gcc-stable/configure \
  --prefix=/usr/local \
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

# clean

cd ..
rm -rf build

# ---- step2 - build gdc on master branch using stable gdc for bootstrap ----

# get GDC sources

git clone --depth 1 -b master https://github.com/D-Programming-GDC/GDC.git gdc

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
git checkout master
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
