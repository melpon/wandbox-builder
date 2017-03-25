#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <version>"
  exit 0
fi

. ../init.sh

VERSION=$1
PREFIX=/opt/wandbox/nim-$VERSION

cd ~/
$PREFIX/bin/nim c $BASE_DIR/resources/test.nim
test "`$BASE_DIR/resources/test`" = "hello"

rm -rf $BASE_DIR/resources/nimcache $BASE_DIR/resources/test
