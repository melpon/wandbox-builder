#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/nim-head

cd ~/
$PREFIX/bin/nim c $BASE_DIR/resources/test.nim
test "`$BASE_DIR/resources/test`" = "hello"

rm -rf $BASE_DIR/resources/nimcache $BASE_DIR/resources/test
