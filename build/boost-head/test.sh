#!/bin/bash

. ./init.sh

if [ $# -lt 2 ]; then
  echo "$0 <version> <compiler>"
  exit 0
fi

set -ex

VERSION=$1
COMPILER=$2

check_version $VERSION $COMPILER

PREFIX=/opt/wandbox/boost-$VERSION/$COMPILER
COMPILER_PREFIX=/opt/wandbox/$COMPILER

if [ "$COMPILER" = "gcc-head" ]; then
  $COMPILER_PREFIX/bin/g++ \
    -I$PREFIX/include \
    -L$PREFIX/lib \
    -Wl,-rpath,$PREFIX/lib \
    -lboost_serialization \
    -lboost_system \
    $BASE_DIR/resources/test.cpp
  ./a.out > /dev/null
  test "`./a.out`" = "`echo -e "23\n0\nSuccess"`"
  rm a.out
elif [ "$COMPILER" = "clang-head" ]; then
  EXTRA_FLAGS="-lc++abi"
  $COMPILER_PREFIX/bin/clang++ \
    -I$COMPILER_PREFIX/include/c++/v1 \
    -L$COMPILER_PREFIX/lib -Wl,-rpath,$COMPILER_PREFIX/lib \
    -stdlib=libc++ \
    -nostdinc++ \
    -I$PREFIX/include \
    -L$PREFIX/lib \
    -Wl,-rpath,$PREFIX/lib \
    -lboost_serialization \
    -lboost_system \
    $EXTRA_FLAGS \
    $BASE_DIR/resources/test.cpp
  ./a.out > /dev/null
  test "`./a.out`" = "`echo -e "23\n0\nSuccess"`"
  rm a.out
else
  exit 1
fi
