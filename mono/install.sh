#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/mono-$VERSION

cd ~/
mkdir mono-$VERSION
cd mono-$VERSION

wget_strict_sha256 \
  https://download.mono-project.com/sources/mono/mono-$VERSION.tar.bz2 \
  $BASE_DIR/resources/mono-$VERSION.tar.bz2.sha256
mkdir mono-$VERSION
cd mono-$VERSION
tar xf ../mono-$VERSION.tar.bz2 --strip-component 1

# apply patches

if compare_version "$VERSION" "<" "3.8.0"; then
  sed -e 's/isinf (1)/isinf (1.0)/g' -i configure
fi

if compare_version "$VERSION" ">=" "3.4.0"; then
  if compare_version "$VERSION" "<" "3.6.0"; then
    cp $BASE_DIR/resources/Microsoft.Portable.Common.targets mcs/tools/xbuild/targets
  fi
fi

# build

export CC="gcc-4.8 -static-libgcc -static-libstdc++"
export CXX="g++-4.8 -static-libgcc -static-libstdc++"
./configure --prefix=$PREFIX --disable-nls --disable-quiet-build --disable-system-aot
if compare_version "$VERSION" "<" "4.0.0"; then
  make -C eglib -j2
  make -C libgc -j2
  make -C mono -j2
  make -j2 || make
else
  make -j2
fi

make install

test_mono $PREFIX

cd ~/
rm -r mono-$VERSION
