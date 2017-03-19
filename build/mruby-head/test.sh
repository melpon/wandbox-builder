#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/mruby-head

test "`$PREFIX/bin/mruby $BASE_DIR/resources/test.rb`" = "hello"
