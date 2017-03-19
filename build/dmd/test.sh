#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/dmd-$VERSION

$PREFIX/linux/bin64/dmd $BASE_DIR/resources/test.d -ofa.out
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
