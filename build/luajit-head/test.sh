#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/luajit-head

test "`$PREFIX/bin/luajit $BASE_DIR/resources/test.lua`" = "hello"
