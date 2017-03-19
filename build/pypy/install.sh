#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/pypy-$VERSION

case "$VERSION" in
  "2.1" ) LONG_VERSION="pypy-2.1" ;;
  "2.6.1" ) LONG_VERSION="pypy-2.6.1" ;;
  "4.0.1" ) LONG_VERSION="pypy-4.0.1" ;;
  "5.5.0" ) LONG_VERSION="pypy3.3-v5.5.0-alpha" ;;
  "5.6.0" ) LONG_VERSION="pypy2-v5.6.0" ;;
  * ) exit 1
esac


# get sources

cd ~/
wget_strict_sha256 \
  https://bitbucket.org/pypy/pypy/downloads/${LONG_VERSION}-linux64.tar.bz2 \
  $BASE_DIR/resources/${LONG_VERSION}-linux64.tar.bz2.sha256

mkdir $LONG_VERSION
tar xf ${LONG_VERSION}-linux64.tar.bz2 -C $LONG_VERSION --strip-components=1

# install

rm -r $PREFIX || true
cp -r ${LONG_VERSION} $PREFIX

# make pypy

if [ ! -e $PREFIX/bin/pypy ]; then
  ln -s $PREFIX/bin/pypy3 $PREFIX/bin/pypy
fi

# version

PYPY_VERSION=`/opt/wandbox/pypy-$VERSION/bin/pypy --version 2>&1 | tail -n 1 | cut -d' ' -f2`
CPYTHON_VERSION=`/opt/wandbox/pypy-$VERSION/bin/pypy --version 2>&1 | head -n 1 | cut -d' ' -f2`

echo "$PYPY_VERSION cpython-$CPYTHON_VERSION" > $PREFIX/VERSION

rm -r ~/*
