#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/rust-head

$PREFIX/bin/rustc $BASE_DIR/resources/test.rs
test "`./test`" = "hello"
rm test
