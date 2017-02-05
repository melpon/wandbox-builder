#!/bin/bash

. ../init.sh

function test_gdc() {
  prefix=$1
  $prefix/bin/gdc $BASE_DIR/resources/test.d && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}
