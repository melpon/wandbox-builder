#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find branches from https://hg.python.org/cpython/branches"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/cpython-$VERSION

if [ "$VERSION" = "head" ]; then
  BRANCH=default
elif [ "$VERSION" = "2.7-head" ]; then
  BRANCH=2.7
else
  exit 1
fi

# get sources

cd ~/
hg clone https://hg.python.org/cpython
cd cpython
hg update $BRANCH

# build

./configure --enable-optimizations --prefix=$PREFIX
make -j2
make install


if [ "$VERSION" = "head" ]; then
  PYTHON=python3
elif [ "$VERSION" = "2.7-head" ]; then
  PYTHON=python
else
  exit 1
fi
test_cpython $PREFIX/bin/$PYTHON

rm -r ~/cpython
