#!/bin/bash

. ../init.sh

BOOTSTRAP_VERSION=3.0.2
PREFIX=/opt/wandbox/fpc-head

$PREFIX/bin/run-fpc.sh $BASE_DIR/resources/test.pas && test "`$BASE_DIR/resources/test`" = "hello" && rm $BASE_DIR/resources/test
