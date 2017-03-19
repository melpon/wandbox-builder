#!/bin/bash

. ./init.sh

if [ $# -lt 3 ]; then
  echo "$0 <version> <compiler> <compiler_version>"
  exit 0
fi

set -ex

VERSION=$1
COMPILER=$2
COMPILER_VERSION=$3

check_version $VERSION $COMPILER $COMPILER_VERSION

PREFIX=/opt/wandbox/boost-$VERSION/$COMPILER-$COMPILER_VERSION
COMPILER_PREFIX=/opt/wandbox/$COMPILER-$COMPILER_VERSION

if [ "$COMPILER" = "gcc" ]; then
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
elif [ "$COMPILER" = "clang" ]; then
  if compare_version "$COMPILER_VERSION" ">=" "3.5.0"; then
    EXTRA_FLAGS="-lc++abi"
  fi

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
