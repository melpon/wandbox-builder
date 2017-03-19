#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/dmd-head

$PREFIX/linux/bin64/dmd $BASE_DIR/resources/test.d -ofa.out
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
