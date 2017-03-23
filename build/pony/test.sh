#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/pony-$VERSION

cd ~/
$PREFIX/bin/ponyc $BASE_DIR/resources/test
test "`./test`" = "hello"
rm test
