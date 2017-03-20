#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/sbcl-head

test "`$PREFIX/bin/run-sbcl.sh --script $BASE_DIR/resources/test.lisp`" = "hello"
