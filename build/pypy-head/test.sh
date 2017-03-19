#!/bin/bash

. ../init.sh

VERSION=$1
PREFIX=/opt/wandbox/pypy-head

test "`$PREFIX/bin/pypy $BASE_DIR/resources/test.py`" = "hello"
