#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/fpc-$VERSION

$PREFIX/bin/run-fpc.sh $BASE_DIR/resources/test.pas
test "`$BASE_DIR/resources/test`" = "hello"
rm $BASE_DIR/resources/test
