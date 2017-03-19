#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://github.com/mruby/mruby/releases"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/mruby-$VERSION

test "`$PREFIX/bin/mruby $BASE_DIR/resources/test.rb`" = "hello"
