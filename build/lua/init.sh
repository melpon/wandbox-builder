#!/bin/bash

. ../init.sh

function test_lua() {
  prefix=$1
  test "`$prefix/bin/lua $BASE_DIR/resources/test.lua`" = "hello"
}
