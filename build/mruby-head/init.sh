#!/bin/bash

. ../init.sh

function test_mruby() {
  prefix=$1
  $prefix/bin/mruby $BASE_DIR/resources/test.rb > /dev/null && test "`$prefix/bin/mruby $BASE_DIR/resources/test.rb`" = "hello"
}
