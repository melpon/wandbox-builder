#!/bin/bash

. ../init.sh

function test_groovy() {
  prefix=$1
  test "`$prefix/bin/run-groovy.sh $BASE_DIR/resources/test.groovy`" = "hello"
}
