#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/sqlite-$VERSION

test "`cat $BASE_DIR/resources/test.sql | $PREFIX/bin/sqlite3`" = "hello"
