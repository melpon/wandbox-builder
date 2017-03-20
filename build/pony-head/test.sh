#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/pony-head

cd ~/
$PREFIX/bin/ponyc $BASE_DIR/resources/test
test "`./test`" = "hello"
rm test
