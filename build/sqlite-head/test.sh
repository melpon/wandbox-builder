#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/sqlite-head

test "`cat $BASE_DIR/resources/test.sql | $PREFIX/bin/sqlite3`" = "hello"
