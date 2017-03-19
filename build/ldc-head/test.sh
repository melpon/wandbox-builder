#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ldc-head

cd ~/
$PREFIX/bin/ldc2 $BASE_DIR/resources/test.d
test "`./test`" = "hello"
rm test test.o
