#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/groovy-head

test "`$PREFIX/bin/run-groovy.sh $BASE_DIR/resources/test.groovy`" = "hello"
