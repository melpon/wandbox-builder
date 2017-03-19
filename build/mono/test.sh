#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/mono-$VERSION

cd ~/

$PREFIX/bin/mcs $BASE_DIR/resources/test.cs -out:a.out
$PREFIX/bin/mono a.out > /dev/null
test "`$PREFIX/bin/mono a.out`" = "hello"
rm a.out
