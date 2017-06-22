#!/bin/bash

. ../init.sh

if [ $# -lt 1 ]; then
  echo "$0 <version>"
  exit 0
fi

VERSION=$1
PREFIX=/opt/wandbox/erlang-$VERSION

$PREFIX/bin/erlc $BASE_DIR/resources/test.erl
test "`$PREFIX/bin/erl test.beam -noshell -eval 'test:main()' -eval 'init:stop()'`" = "hello"
rm test.beam
