#!/bin/bash

. ../init.sh

function test_nodejs() {
  prefix=$1
  test "`$prefix/bin/node $BASE_DIR/resources/test.js`" = "hello"
}
