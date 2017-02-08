#!/bin/bash

. ./init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://hg.python.org/cpython/tags"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/cpython-$VERSION

# get sources

cd ~/
hg clone https://hg.python.org/cpython
cd cpython
hg update v$VERSION

# build

./configure --enable-optimizations --prefix=$PREFIX
make -j2
make install


if compare_version "$VERSION" "<" "3.0.0"; then
  PYTHON=python
else
  PYTHON=python3
fi
test_cpython $PREFIX/bin/$PYTHON

rm -r ~/cpython
