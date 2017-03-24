#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/crystal-head

cd ~/
test "`$PREFIX/bin/crystal $BASE_DIR/resources/test.cr`" = "hello"
