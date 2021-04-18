#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)
cd $BASE_DIR

. ../init-common.sh

if [ "$SUBCOMMAND" == "setup" ]; then
  exit 0
fi

# get binary

curl_strict_sha256 \
  https://downloads.python.org/pypy/pypy$VERSION-linux64.tar.bz2 \
  $BASE_DIR/resources/pypy$VERSION-linux64.tar.bz2.sha256

mkdir $VERSION
tar xf pypy$VERSION-linux64.tar.bz2 -C $VERSION --strip-components=1

# install

mkdir -p `dirname $PREFIX`
cp -r $VERSION $PREFIX

# make pypy

if [ ! -e $PREFIX/bin/pypy ]; then
  ln -s $PREFIX/bin/pypy3 $PREFIX/bin/pypy
fi

# version

PYPY_VERSION=`/opt/wandbox/pypy-$VERSION/bin/pypy --version 2>&1 | tail -n 1 | cut -d' ' -f2`
CPYTHON_VERSION=`/opt/wandbox/pypy-$VERSION/bin/pypy --version 2>&1 | head -n 1 | cut -d' ' -f2`

echo "$PYPY_VERSION cpython-$CPYTHON_VERSION" > $PREFIX/VERSION

archive_install $PREFIX $PACKAGE_PATH $PACKAGE_FILENAME
