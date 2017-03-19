#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/php-$VERSION

test "`$PREFIX/bin/php $BASE_DIR/resources/test.php`" = "hello"
