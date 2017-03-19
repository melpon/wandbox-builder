#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/erlang-$VERSION

test "`$PREFIX/bin/escript $BASE_DIR/resources/test.erl`" = "hello"
