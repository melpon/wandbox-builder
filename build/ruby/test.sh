#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://cache.ruby-lang.org/pub/ruby/"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/ruby-$VERSION

test "`$PREFIX/bin/ruby $BASE_DIR/resources/test.rb`" = "hello"
