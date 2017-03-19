#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/lua-$VERSION

test "`$PREFIX/bin/lua $BASE_DIR/resources/test.lua`" = "hello"
