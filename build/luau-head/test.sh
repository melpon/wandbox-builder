#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/luau-head

test "`$PREFIX/bin/luau $BASE_DIR/resources/test.lua`" = "hello"
test "`$PREFIX/bin/run-luau-analyze.sh $BASE_DIR/resources/test.lua`" = ""
