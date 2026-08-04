#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/luau-$VERSION

test "`$PREFIX/bin/luau $BASE_DIR/resources/test.lua`" = "hello"
test "`$PREFIX/bin/run-luau-analyze.sh $BASE_DIR/resources/test.lua`" = ""
