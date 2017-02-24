#!/bin/bash

. ../init.sh

function test_erlang() {
  prefix=$1
  test "`$prefix/bin/run-escript.sh $BASE_DIR/resources/test.erl`" = "hello"
}
