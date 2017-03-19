#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/spidermonkey-$VERSION

test "`$PREFIX/bin/js $BASE_DIR/resources/test.js`" = "hello"
