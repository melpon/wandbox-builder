#!/bin/bash

. ../init.sh

function test_php() {
  prefix=$1
  test "`$prefix/bin/php $BASE_DIR/resources/test.php`" = "hello"
}
