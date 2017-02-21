#!/bin/bash

. ../init.sh

function test_sqlite() {
  prefix=$1
  test "`cat $BASE_DIR/resources/test.sql | $prefix/bin/sqlite3`" = "hello"
}
