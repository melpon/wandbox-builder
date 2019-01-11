#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  echo "  find versions from http://hg.openjdk.java.net/jdk/jdk11/tags"
  echo "                     http://hg.openjdk.java.net/jdk10/jdk10/tags"
  echo "                     http://hg.openjdk.java.net/jdk9/jdk9/tags"
  echo "                     http://hg.openjdk.java.net/jdk8u/jdk8u/tags"
  echo "                     http://hg.openjdk.java.net/jdk7u/jdk7u/tags"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/openjdk-$VERSION

cd $BASE_DIR/resources
$PREFIX/bin/javac test.java
test "`$PREFIX/bin/run-java.sh`" = "hello"
rm test.class
