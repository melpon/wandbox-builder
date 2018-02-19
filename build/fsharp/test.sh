#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/fsharp-$VERSION

cd ~/

$PREFIX/bin/run-fsharpc.sh $BASE_DIR/resources/test.fs --out:a.exe --standalone
$PREFIX/bin/run-mono.sh a.exe > /dev/null
test "`$PREFIX/bin/run-mono.sh a.exe`" = "hello"
rm a.exe
