#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/gdc-head

$PREFIX/bin/gdc $BASE_DIR/resources/test.d
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
