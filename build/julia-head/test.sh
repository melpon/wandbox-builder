#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/julia-head

test "`$PREFIX/bin/julia $BASE_DIR/resources/test.jl`" = "hello"
