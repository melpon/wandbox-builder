#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/spidermonkey-$VERSION

# get sources

case "$VERSION" in
  "24.2.0" ) URL=https://ftp.mozilla.org/pub/mozilla.org/js/mozjs-24.2.0.tar.bz2 ;;
  "31.2.0.rc0" ) URL=https://people.mozilla.org/~sstangl/mozjs-31.2.0.rc0.tar.bz2 ;;
  "38.2.1.rc0" ) URL=https://people.mozilla.org/~sstangl/mozjs-38.2.1.rc0.tar.bz2 ;;
  "45.0.2" ) URL=https://people.mozilla.org/~sfink/mozjs-45.0.2.tar.bz2 ;;
  * ) exit 1 ;;
esac

cd ~/
wget_strict_sha256 \
  $URL \
  $BASE_DIR/resources/mozjs-$VERSION.tar.bz2.sha256
mkdir mozjs-$VERSION
tar xf mozjs-$VERSION.tar.bz2 -C mozjs-$VERSION --strip-components=1
cd mozjs-$VERSION

# apply patches

case "$VERSION" in
  "45.0.2" )
    mkdir modules/zlib
    mv modules/src modules/zlib/src
    patch -p1 < $BASE_DIR/resources/0001-Fix-the-zlib-module-in-SM-tarballs.patch
    cp $BASE_DIR/resources/moz.build modules/zlib/
    JOBS="2"
    ;;
  "38.2.1.rc0" )
    cp $BASE_DIR/resources/moz.build modules/zlib/
    JOBS="2"
    ;;
  "31.2.0.rc0" )
    export CXX="g++ -fpermissive"
    JOBS="1"
    ;;
  "24.2.0" )
    export CXX="g++ -fpermissive"
    JOBS="1"
    ;;
  * ) : ;;
esac

# build

cd js/src
autoconf

mkdir build_OPT.OBJ
cd build_OPT.OBJ
SHELL=/bin/bash ../configure --prefix=$PREFIX --disable-shared-js
make -j$JOBS
make install
