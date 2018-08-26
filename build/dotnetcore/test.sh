#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/dotnetcore-$VERSION

cd ~/
cp $BASE_DIR/resources/test.cs Program.cs
$PREFIX/bin/build-dotnet.sh
test "`$PREFIX/bin/run-dotnet.sh`" = "hello"
