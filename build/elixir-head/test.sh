#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/elixir-head

test "`$PREFIX/bin/run-elixir.sh $BASE_DIR/resources/test.exs`" = "hello"
