#!/bin/bash

. ../init.sh

function test_lazyk() {
  prefix=$1
  test "`$prefix/bin/lazyk $BASE_DIR/resources/test.lazy`" = "Hello, world"
}
