#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rill-head

$PREFIX/bin/rillc compile $BASE_DIR/resources/test.rill
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
