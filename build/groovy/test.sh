#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/groovy-$VERSION

test "`$PREFIX/bin/run-groovy.sh $BASE_DIR/resources/test.groovy`" = "hello"
