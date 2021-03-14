#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/julia-$VERSION

test "`$PREFIX/bin/julia $BASE_DIR/resources/test.jl`" = "hello"
