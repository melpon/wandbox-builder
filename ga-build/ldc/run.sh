#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    clang \
    cmake \
    ldc \
    libconfig++-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    llvm-dev
  exit 0
fi

# get sources

curl_strict_sha256 \
  https://github.com/ldc-developers/ldc/releases/download/v$VERSION/ldc-${VERSION}-src.tar.gz \
  $BASE_DIR/resources/ldc-${VERSION}-src.tar.gz.sha256

tar xf ldc-${VERSION}-src.tar.gz

# build
mkdir ldc-${VERSION}-src/build
pushd ldc-${VERSION}-src/build
  cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_SHARED=OFF ..

  # apply patches
  for make in \
      CMakeFiles/ldmd2.dir/build.make \
      CMakeFiles/ldc2.dir/build.make; do
    sed -i 's/-lphobos2-ldc/-Wl,-Bstatic -lphobos2-ldc -Wl,-Bdynamic/g' $make
    sed -i 's/-ldruntime-ldc/-Wl,-Bstatic -ldruntime-ldc -Wl,-Bdynamic/g' $make
    sed -i 's/libconfig.so/libconfig.a/g' $make
  done

  make -j`nproc`
  make install
popd

# version

LDC_VERSION=`/opt/wandbox/ldc-$VERSION/bin/ldc2 --version | head -n 1 | cut -d' ' -f7 | cut -c2- | cut -d')' -f1`
DMD_VERSION=`/opt/wandbox/ldc-$VERSION/bin/ldc2 --version | head -n 2 | tail -n 1 | cut -d' ' -f6 | cut -c2-`

echo "$LDC_VERSION dmd-$DMD_VERSION" > $PREFIX/VERSION

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
