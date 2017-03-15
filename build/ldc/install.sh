#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ldc-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://github.com/ldc-developers/ldc/releases/download/v$VERSION/ldc-${VERSION}-src.tar.gz \
  $BASE_DIR/resources/ldc-${VERSION}-src.tar.gz.sha256

tar xf ldc-${VERSION}-src.tar.gz
cd ldc-${VERSION}-src

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

LDC_VERSION=`/opt/wandbox/ldc-$VERSION/bin/ldc2 --version | head -n 1 | cut -d' ' -f7 | cut -c2- | cut -d')' -f1`
DMD_VERSION=`/opt/wandbox/ldc-$VERSION/bin/ldc2 --version | head -n 2 | tail -n 1 | cut -d' ' -f6 | cut -c2-`

echo "$LDC_VERSION dmd-$DMD_VERSION" > $PREFIX/VERSION

test_ldc $PREFIX
