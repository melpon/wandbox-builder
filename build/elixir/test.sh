#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/elixir-$VERSION

test "`$PREFIX/bin/run-elixir.sh $BASE_DIR/resources/test.exs`" = "hello"
