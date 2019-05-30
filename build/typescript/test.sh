#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/typescript-$VERSION
NODE_PATH=$PREFIX/bin/
TSC_PATH=$PREFIX/node_modules/typescript/bin/

test "`$NODE_PATH/node $TSC_PATH/tsc $BASE_DIR/resources/test.ts` && $NODE_PATH/node $BASE_DIR/resources/test.js" = "hello"
rm $BASE_DIR/resources/test.js
