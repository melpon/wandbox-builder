#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/go-head

test "`$PREFIX/bin/go run $BASE_DIR/resources/test.go`" = "hello"
