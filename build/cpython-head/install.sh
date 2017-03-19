#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/cpython-$VERSION

if [ "$VERSION" = "head" ]; then
  BRANCH=master
elif [ "$VERSION" = "2.7-head" ]; then
  BRANCH=2.7
else
  exit 1
fi

# get sources

cd ~/
git clone --depth 1 --branch $BRANCH https://github.com/python/cpython.git
cd cpython

# build

./configure --enable-optimizations --prefix=$PREFIX
make -j2
make install

rm -r ~/cpython
