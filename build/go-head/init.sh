#!/bin/bash

. ../init.sh

function test_go() {
  prefix=$1
  test "`$prefix/bin/go run $BASE_DIR/resources/test.go`" = "hello"
}
