#!/bin/bash

. ../init.sh

function test_swift() {
  prefix=$1
  $prefix/usr/bin/swiftc $BASE_DIR/resources/test.swift && ./test > /dev/null && test "`./test`" = "hello" && rm test
}
