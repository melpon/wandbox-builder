#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  sudo apt-get install -y \
    mono-devel \
    python3
  exit 0
fi

EXT=xz
if compare_version "$VERSION" "<" "6.0.0"; then
  EXT=bz2
fi

curl_strict_sha256 \
  https://download.mono-project.com/sources/mono/mono-$VERSION.tar.$EXT \
  $BASE_DIR/resources/mono-$VERSION.tar.$EXT.sha256

mkdir mono-$VERSION
pushd mono-$VERSION
  tar xf ../mono-$VERSION.tar.$EXT --strip-component 1

  # build
  export CC="gcc -static-libgcc -static-libstdc++"
  export CXX="g++ -static-libgcc -static-libstdc++"
  ./configure --prefix=$PREFIX --disable-nls --disable-quiet-build --disable-system-aot
  make -j`nproc`
  make install
popd

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
