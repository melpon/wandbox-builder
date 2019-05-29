#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION

test "`$PREFIX/node_modules/typescript/bin/tsc $BASE_DIR/resources/test.ts` && node $BASE_DIR/resources/test.js" = "hello"
rm $BASE_DIR/resources/test.js
