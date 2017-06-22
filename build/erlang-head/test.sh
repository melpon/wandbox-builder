#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/erlang-head

$PREFIX/bin/erlc $BASE_DIR/resources/test.erl
test "`$PREFIX/bin/erl test.beam -noshell -eval 'test:main()' -eval 'init:stop()'`" = "hello"
rm test.beam
