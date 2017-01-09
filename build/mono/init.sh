#!/bin/bash

. ../init.sh

function test_mono() {
  prefix=$1
  $prefix/bin/mcs $BASE_DIR/resources/test.cs -out:a.out && $prefix/bin/mono a.out > /dev/null && test "`$prefix/bin/mono a.out`" = "hello" && rm a.out
}
