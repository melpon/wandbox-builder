#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION

MAJOR=${VERSION:0:1}
MINOR=${VERSION:2:1}
PATCH=${VERSION:4:1}

# if $VERSION is less than or equal 1.3.0 then --target es5 else --target es6
if [ $MAJOR = 1 ] && [ $MINOR -le 3 ]; then
  $PREFIX/bin/run-tsc.sh $BASE_DIR/resources/test.ts --target es5
else
  $PREFIX/bin/run-tsc.sh $BASE_DIR/resources/test.ts --target es6
fi


test "`$PREFIX/bin/run-node.sh $BASE_DIR/resources/test.js`" = "hello"
rm $BASE_DIR/resources/test.js
