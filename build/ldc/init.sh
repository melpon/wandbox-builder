#!/bin/bash

. ../init.sh

function test_ldc() {
  prefix=$1
  $prefix/bin/ldc2 $BASE_DIR/resources/test.d && test "`./test`" = "hello" && rm test test.o
}
