#!/bin/bash

. ../init.sh

function test_cpython() {
  python=$1
  $python $BASE_DIR/resources/test.py > /dev/null && test "`$python $BASE_DIR/resources/test.py`" = "hello"
}
