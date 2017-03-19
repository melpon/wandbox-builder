#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ghc-head

$PREFIX/bin/ghc $BASE_DIR/resources/test.hs -o a.out
./a.out > /dev/null
test "`./a.out`" = "hello"
rm a.out
