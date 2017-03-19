#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/clisp-$VERSION

test "`$PREFIX/bin/clisp $BASE_DIR/resources/test.lisp`" = "hello"
