#!/bin/bash

. ../init.sh

function test_dmd() {
  prefix=$1
  $prefix/linux/bin64/dmd $BASE_DIR/resources/test.d -ofa.out && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}
