#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/perl-head

test "`$PREFIX/bin/perl $BASE_DIR/resources/test.pl`" = "hello"
