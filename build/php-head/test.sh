#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/php-head

test "`$PREFIX/bin/php $BASE_DIR/resources/test.php`" = "hello"
