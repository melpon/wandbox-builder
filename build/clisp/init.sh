#!/bin/bash

. ../init.sh

function test_clisp() {
  prefix=$1
  test "`$prefix/bin/clisp $BASE_DIR/resources/test.lisp`" = "hello"
}
