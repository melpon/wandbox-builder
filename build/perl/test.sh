#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/perl-$VERSION

test "`$PREFIX/bin/perl $BASE_DIR/resources/test.pl`" = "hello"
