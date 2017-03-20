#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/sbcl-$VERSION

# get sources

cd ~/
wget_strict_sha256 \
  https://downloads.sourceforge.net/project/sbcl/sbcl/$VERSION/sbcl-${VERSION}-source.tar.bz2 \
  $BASE_DIR/resources/sbcl-${VERSION}-source.tar.bz2.sha256

tar xf sbcl-${VERSION}-source.tar.bz2
cd sbcl-${VERSION}

# apply patches

sed -i 's/with-timeout 10/with-timeout 60/g' contrib/sb-concurrency/tests/test-frlock.lisp

if compare_version "$VERSION" "==" "1.2.16"; then
  patch -p1 < $BASE_DIR/resources/sb-bsd-sockets-1.2.16.patch
fi

# build

export INSTALL_ROOT="$PREFIX"

sh make.sh
sh install.sh

cp $BASE_DIR/resources/run-sbcl.sh.in $PREFIX/bin/run-sbcl.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/run-sbcl.sh
chmod +x $PREFIX/bin/run-sbcl.sh

rm -r ~/*
