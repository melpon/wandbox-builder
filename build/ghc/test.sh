#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ghc-$VERSION

$PREFIX/bin/ghc $BASE_DIR/resources/test.hs -o a.out
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
