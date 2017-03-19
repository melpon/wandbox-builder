#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from https://github.com/scala/scala/releases"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/scala-$VERSION

cd $BASE_DIR/resources
$PREFIX/bin/run-scalac.sh test.scala
test "`$PREFIX/bin/run-scala.sh`" = "hello"
rm *.class
