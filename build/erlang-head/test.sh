#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/erlang-head

test "`$PREFIX/bin/run-escript.sh $BASE_DIR/resources/test.erl`" = "hello"
