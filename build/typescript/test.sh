#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION

test "`$PREFIX/bin/run-tsc.sh $BASE_DIR/resources/test.ts` && $PREFIX/bin/run-node.sh $BASE_DIR/resources/test.js" = "hello"
rm $BASE_DIR/resources/test.js
