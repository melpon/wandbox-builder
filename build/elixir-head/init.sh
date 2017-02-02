#!/bin/bash

. ../init.sh

function test_elixir() {
  prefix=$1
  test "`$prefix/bin/run-elixir.sh $BASE_DIR/resources/test.exs`" = "hello"
}
