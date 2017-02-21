#!/bin/bash

. ../init.sh

function test_gcc() {
  prefix=$1
  $prefix/bin/g++ $BASE_DIR/resources/test.cpp && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}
