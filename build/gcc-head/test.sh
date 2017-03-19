#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/gcc-head

$PREFIX/bin/g++ $BASE_DIR/resources/test.cpp
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
