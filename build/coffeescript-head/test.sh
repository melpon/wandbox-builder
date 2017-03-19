#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/coffeescript-head

test "`$PREFIX/bin/run-coffee.sh $BASE_DIR/resources/test.coffee`" = "hello"
