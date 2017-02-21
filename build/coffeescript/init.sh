#!/bin/bash

. ../init.sh

function test_coffeescript() {
  prefix=$1
  test "`$prefix/bin/run-coffee.sh $BASE_DIR/resources/test.coffee`" = "hello"
}
