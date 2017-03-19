#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ldc-$VERSION

cd ~/
$PREFIX/bin/ldc2 $BASE_DIR/resources/test.d
test "`./test`" = "hello"
rm test test.o
