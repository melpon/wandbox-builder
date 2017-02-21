#!/bin/bash

. ../init.sh

function test_openjdk() {
  prefix=$1
  pushd $BASE_DIR/resources
  $prefix/bin/javac test.java && test "`$prefix/bin/run-java.sh`" = "hello" && rm test.class
  popd
}
