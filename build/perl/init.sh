#!/bin/bash

. ../init.sh

function test_perl() {
  prefix=$1
  test "`$prefix/bin/perl $BASE_DIR/resources/test.pl`" = "hello"
}
