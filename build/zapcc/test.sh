#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

set -ex

VERSION=$1
PREFIX=/opt/wandbox/zapcc-$VERSION
CLANG_PREFIX=/opt/wandbox/clang-head

EXTRA_FLAGS="-stdlib=libc++ -nostdinc++ -lc++abi"

$PREFIX/bin/zapcc++ \
  -I$CLANG_PREFIX/include/c++/v1 \
  -L$CLANG_PREFIX/lib \
  -Wl,-rpath,$CLANG_PREFIX/lib \
  $EXTRA_FLAGS \
  $BASE_DIR/resources/test.cpp
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
