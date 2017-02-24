#!/bin/bash

. ../init.sh

function test_pypy() {
  prefix=$1
  test "`$prefix/bin/pypy $BASE_DIR/resources/test.py`" = "hello"
}
