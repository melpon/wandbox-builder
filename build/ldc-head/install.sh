#!/bin/bash

. ./init.sh

PREFIX=/opt/wandbox/ldc-head

# get sources

cd ~/
git clone --depth 1 https://github.com/ldc-developers/ldc.git

cd ldc
git submodule update --recursive --init

# build

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_SHARED=OFF ..

# apply patches
for make in \
    CMakeFiles/ldmd2.dir/build.make \
    CMakeFiles/ldc2.dir/build.make; do
  sed -i 's/-lphobos2-ldc/-Wl,-Bstatic -lphobos2-ldc -Wl,-Bdynamic/g' $make
  sed -i 's/-ldruntime-ldc/-Wl,-Bstatic -ldruntime-ldc -Wl,-Bdynamic/g' $make
  sed -i 's/libconfig.so/libconfig.a/g' $make
done

make -j2
make install

# version

LDC_VERSION=`$PREFIX/bin/ldc2 --version | head -n 1 | cut -d' ' -f7 | cut -c2- | cut -d')' -f1`
DMD_VERSION=`$PREFIX/bin/ldc2 --version | head -n 2 | tail -n 1 | cut -d' ' -f6 | cut -c2-`

echo "$LDC_VERSION dmd-$DMD_VERSION" > $PREFIX/VERSION

test_ldc $PREFIX
