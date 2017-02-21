#!/bin/bash

. ../init.sh

function test_rust() {
  prefix=$1
  $prefix/bin/rustc $BASE_DIR/resources/test.rs && ./test > /dev/null && test "`./test`" = "hello" && rm test
}
