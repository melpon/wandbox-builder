#!/bin/bash

. ../init.sh

function test_ruby() {
  prefix=$1
  $prefix/bin/ruby $BASE_DIR/resources/test.rb > /dev/null && test "`$prefix/bin/ruby $BASE_DIR/resources/test.rb`" = "hello"
}
