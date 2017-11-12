#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/luajit-$VERSION

test "`$PREFIX/bin/luajit $BASE_DIR/resources/test.lua`" = "hello"
