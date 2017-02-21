#!/bin/bash

. ../init.sh

function test_spidermonkey() {
  prefix=$1
  test "`$prefix/bin/js $BASE_DIR/resources/test.js`" = "hello"
}
