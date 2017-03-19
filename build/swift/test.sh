#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/swift-$VERSION

cd ~/
$PREFIX/usr/bin/swiftc $BASE_DIR/resources/test.swift
test "`./test`" = "hello"
rm test
