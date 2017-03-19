#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/rust-$VERSION

$PREFIX/bin/rustc $BASE_DIR/resources/test.rs
test "`./test`" = "hello"
rm test
