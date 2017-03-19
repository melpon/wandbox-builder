#!/bin/bash

. ../init.sh

set -ex

PREFIX=/opt/wandbox/clang-head
EXTRA_FLAGS="-lc++abi"

$PREFIX/bin/clang++ \
  -I$PREFIX/include/c++/v1 \
  -L$PREFIX/lib \
  -Wl,-rpath,$PREFIX/lib \
  -stdlib=libc++ \
  -nostdinc++ \
  $EXTRA_FLAGS \
  $BASE_DIR/resources/test.cpp
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
