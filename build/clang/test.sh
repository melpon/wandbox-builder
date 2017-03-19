#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

set -ex

VERSION=$1
PREFIX=/opt/wandbox/clang-$VERSION

if compare_version "$VERSION" "<=" "3.2"; then
  EXTRA_FLAGS="-I/usr/include/c++/5 -I/usr/include/x86_64-linux-gnu/c++/5"
elif compare_version "$VERSION" "<=" "3.5.0"; then
  EXTRA_FLAGS="-stdlib=libc++ -nostdinc++"
else
  EXTRA_FLAGS="-stdlib=libc++ -nostdinc++ -lc++abi"
fi

$PREFIX/bin/clang++ \
  -I$PREFIX/include/c++/v1 \
  -L$PREFIX/lib \
  -Wl,-rpath,$PREFIX/lib \
  $EXTRA_FLAGS \
  $BASE_DIR/resources/test.cpp
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
