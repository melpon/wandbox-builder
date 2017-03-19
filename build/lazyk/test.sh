#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/lazyk

test "`$PREFIX/bin/lazyk $BASE_DIR/resources/test.lazy`" = "Hello, world"
