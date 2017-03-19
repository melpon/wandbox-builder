#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/gcc-$VERSION

$PREFIX/bin/g++ $BASE_DIR/resources/test.cpp
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
