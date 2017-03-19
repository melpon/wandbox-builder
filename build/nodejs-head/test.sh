#!/bin/bash

. ../init.sh

VERSION=$1
PREFIX=/opt/wandbox/nodejs-head

test "`$PREFIX/bin/node $BASE_DIR/resources/test.js`" = "hello"
