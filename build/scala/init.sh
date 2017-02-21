#!/bin/bash

. ../init.sh

function test_scala() {
  prefix=$1
  pushd $BASE_DIR/resources
  $prefix/bin/run-scalac.sh test.scala && test "`$prefix/bin/run-scala.sh`" = "hello" && rm *.class
  popd
}
