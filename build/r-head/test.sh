#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/r-head

test "`$PREFIX/bin/Rscript $BASE_DIR/resources/test.R`" = "hello"
