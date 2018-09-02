#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/r-$VERSION

test "`$PREFIX/bin/Rscript $BASE_DIR/resources/test.R`" = "hello"
