#!/bin/bash

. ../init.sh

function test_fpc() {
  prefix=$1
  $prefix/bin/run-fpc.sh $BASE_DIR/resources/test.pas && test "`$BASE_DIR/resources/test`" = "hello" && rm $BASE_DIR/resources/test
}
