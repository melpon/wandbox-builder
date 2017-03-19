#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/pypy-$VERSION

test "`$PREFIX/bin/pypy $BASE_DIR/resources/test.py`" = "hello"
