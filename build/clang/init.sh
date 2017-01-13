#!/bin/bash

. ../init.sh

function test_clang() {
  prefix=$1
  extra_flags=$2
  $prefix/bin/clang++ -I$prefix/include/c++/v1 -L$prefix/lib -Wl,-rpath,$prefix/lib $extra_flags $BASE_DIR/resources/test.cpp && ./a.out > /dev/null && test "`./a.out`" = "hello" && rm a.out
}
