#!/bin/bash

. ../init.sh

function test_ghc() {
  prefix=$1
  $prefix/bin/ghc $BASE_DIR/resources/test.hs -o a.out && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}
