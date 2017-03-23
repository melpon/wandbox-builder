#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/crystal-$VERSION

cd ~/
test "`$PREFIX/bin/crystal $BASE_DIR/resources/test.cr`" = "hello"
